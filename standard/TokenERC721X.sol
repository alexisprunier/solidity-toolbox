pragma solidity ^0.5.6;

import "./../../Interfaces/ERC721X.sol";

import "./../../Interfaces/ERC721XReceiver.sol";
import "./ERC721XTokenNFT.sol";

import "openzeppelin-solidity/contracts/utils/Address.sol";
import "./../../Libraries/ObjectsLib.sol";


// Additional features over NFT token that is compatible with batch transfers
contract ERC721XToken is ERC721X, ERC721XTokenNFT {

    using ObjectLib for ObjectLib.Operations;
    using Address for address;

    bytes4 internal constant ERC721X_RECEIVED = 0x660b3370;
    bytes4 internal constant ERC721X_BATCH_RECEIVE_SIG = 0xe9e5be6a;

    event BatchTransfer(address from, address to, uint256[] tokenTypes, uint256[] amounts);

    constructor(string memory _baseTokenURI) public ERC721XTokenNFT(_baseTokenURI) {}


    modifier isOperatorOrOwner(address _from) {
        require((msg.sender == _from) || operators[_from][msg.sender], "msg.sender is neither _from nor operator");
        _;
    }

    function implementsERC721X() public pure returns (bool) {
        return true;
    }

    /**
     * @dev transfer objects from different tokenIds to specified address
     * @param _from The address to BatchTransfer objects from.
     * @param _to The address to batchTransfer objects to.
     * @param _tokenIds Array of tokenIds to update balance of
     * @param _amounts Array of amount of object per type to be transferred.
     * Note:  Arrays should be sorted so that all tokenIds in a same bin are adjacent (more efficient).
     */
    function _batchTransferFrom(address _from, address _to, uint256[] memory _tokenIds, uint256[] memory _amounts)
        internal
        isOperatorOrOwner(_from)
    {

        // Requirements
        require(_tokenIds.length == _amounts.length, "Inconsistent array length between args");
        require(_to != address(0), "Invalid recipient");

        if (tokenType[_tokenIds[0]] == NFT) {
            tokenOwner[_tokenIds[0]] = _to;
            emit Transfer(_from, _to, _tokenIds[0]);
        }

        // Load first bin and index where the object balance exists
        (uint256 bin, uint256 index) = ObjectLib.getTokenBinIndex(_tokenIds[0]);

        // Balance for current bin in memory (initialized with first transfer)
        // Written with bad library syntax instead of as below to bypass stack limit error
        uint256 balFrom = ObjectLib.updateTokenBalance(
            packedTokenBalance[_from][bin], index, _amounts[0], ObjectLib.Operations.SUB
        );
        uint256 balTo = ObjectLib.updateTokenBalance(
            packedTokenBalance[_to][bin], index, _amounts[0], ObjectLib.Operations.ADD
        );

        // Number of transfers to execute
        uint256 nTransfer = _tokenIds.length;

        // Last bin updated
        uint256 lastBin = bin;

        for (uint256 i = 1; i < nTransfer; i++) {
            // If we're transferring an NFT we additionally should update the tokenOwner and emit the corresponding event
            if (tokenType[_tokenIds[i]] == NFT) {
                tokenOwner[_tokenIds[i]] = _to;
                emit Transfer(_from, _to, _tokenIds[i]);
            }
            (bin, index) = _tokenIds[i].getTokenBinIndex();

            // If new bin
            if (bin != lastBin) {
                // Update storage balance of previous bin
                packedTokenBalance[_from][lastBin] = balFrom;
                packedTokenBalance[_to][lastBin] = balTo;

                // Load current bin balance in memory
                balFrom = packedTokenBalance[_from][bin];
                balTo = packedTokenBalance[_to][bin];

                // Bin will be the most recent bin
                lastBin = bin;
            }

            // Update memory balance
            balFrom = balFrom.updateTokenBalance(index, _amounts[i], ObjectLib.Operations.SUB);
            balTo = balTo.updateTokenBalance(index, _amounts[i], ObjectLib.Operations.ADD);
        }

        // Update storage of the last bin visited
        packedTokenBalance[_from][bin] = balFrom;
        packedTokenBalance[_to][bin] = balTo;

        // Emit batchTransfer event
        emit BatchTransfer(_from, _to, _tokenIds, _amounts);
    }

    function batchTransferFrom(address _from, address _to, uint256[] memory _tokenIds, uint256[] memory _amounts) public {
        // Batch Transfering
        _batchTransferFrom(_from, _to, _tokenIds, _amounts);
    }

    /**
     * @dev transfer objects from different tokenIds to specified address
     * @param _from The address to BatchTransfer objects from.
     * @param _to The address to batchTransfer objects to.
     * @param _tokenIds Array of tokenIds to update balance of
     * @param _amounts Array of amount of object per type to be transferred.
     * @param _data Data to pass to onERC721XReceived() function if recipient is contract
     * Note:  Arrays should be sorted so that all tokenIds in a same bin are adjacent (more efficient).
     */
    function safeBatchTransferFrom(
        address _from,
        address _to,
        uint256[] memory _tokenIds,
        uint256[] memory _amounts,
        bytes memory _data
    )
        public
    {

        // Batch Transfering
        _batchTransferFrom(_from, _to, _tokenIds, _amounts);

        // Pass data if recipient is contract
        if (_to.isContract()) {
            bytes4 retval = ERC721XReceiver(_to).onERC721XBatchReceived(
                msg.sender, _from, _tokenIds, _amounts, _data
            );
            require(retval == ERC721X_BATCH_RECEIVE_SIG);
        }
    }

    function transfer(address _to, uint256 _tokenId, uint256 _amount) public {
        _transferFrom(msg.sender, _to, _tokenId, _amount);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId, uint256 _amount) public {
        _transferFrom(_from, _to, _tokenId, _amount);
    }

    function _transferFrom(address _from, address _to, uint256 _tokenId, uint256 _amount)
        internal
        isOperatorOrOwner(_from)
    {
        require(tokenType[_tokenId] == FT);
        require(_amount <= balanceOf(_from, _tokenId), "Quantity greater than from balance");
        require(_to != address(0), "Invalid to address");

        _updateTokenBalance(_from, _tokenId, _amount, ObjectLib.Operations.SUB);
        _updateTokenBalance(_to, _tokenId, _amount, ObjectLib.Operations.ADD);
        emit TransferWithQuantity(_from, _to, _tokenId, _amount);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, uint256 _amount) public {
        safeTransferFrom(_from, _to, _tokenId, _amount, "");
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, uint256 _amount, bytes memory _data) public {
        _transferFrom(_from, _to, _tokenId, _amount);
        require(
            checkAndCallSafeTransfer(_from, _to, _tokenId, _amount, _data),
            "Sent to a contract which is not an ERC721X receiver"
        );
    }

    function _mint(uint256 _tokenId, address _to, uint256 _supply) internal {
        // If the token doesn't exist, add it to the tokens array
        if (!exists(_tokenId)) {
            tokenType[_tokenId] = FT;
            allTokens.push(_tokenId);
        } else {
            // if the token exists, it must be a FT
            require(tokenType[_tokenId] == FT, "Not a FT");
        }

        _updateTokenBalance(_to, _tokenId, _supply, ObjectLib.Operations.ADD);
        emit TransferWithQuantity(address(this), _to, _tokenId, _supply);
    }


    function checkAndCallSafeTransfer(
        address _from,
        address _to,
        uint256 _tokenId,
        uint256 _amount,
        bytes memory _data
    )
        internal
        returns (bool)
    {
        if (!_to.isContract()) {
            return true;
        }

        bytes4 retval = ERC721XReceiver(_to).onERC721XReceived(
            msg.sender, _from, _tokenId, _amount, _data);
        return(retval == ERC721X_RECEIVED);
    }

}