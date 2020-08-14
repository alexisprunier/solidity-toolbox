pragma solidity ^0.5.9; 

contract DataTypesSpecific {

    // ADRESSE

    // In Ethereum and Solidity, an address if of 20 bytesvalue size (160 bits or 40 hex characters).

    address ad = 0xc0ffee254729296a45a3885639AC7E10F9d54979

    ad.balance                                  // (uint256) Balance of the Address in Wei
    ad.transfer(uint256 amount):                // Send given amount of Wei to Address, throws on failure, forwards 2300 gas stipend, not adjustable
    ad.send(uint256 amount) returns (bool):     // Send given amount of Wei to Address, returns false on failure, forwards 2300 gas stipend, not adjustable
    ad.call(...) returns (bool):                // Issue low-level CALL, returns false on failure, forwards all available gas, adjustable
    ad.callcode(...) returns (bool):            // Issue low-level CALLCODE, returns false on failure, forwards all available gas, adjustable
    ad.delegatecall(...) returns (bool)         // Issue low-level DELEGATECALL, returns false on failure, forwards all available gas, adjustable


    // BLOCK

    block.coinbase      // (address) Current block miner’s address
    block.difficulty    // (uint) Current block difficulty
    block.gaslimit      // (uint) Current block gaslimit
    block.number        // (uint) Current block number
    block.timestamp     // (uint) Current block timestamp as seconds since unix epoch


    // MESSAGE

    msg.data        // (bytes) Complete calldata
    msg.gas         // (uint) Remaining gas - deprecated in version 0.4.21 and to be replaced by gasleft()
    msg.sender      // (address) Sender of the message (current call)
    msg.sig         // (bytes4) First four bytes of the calldata (i.e. function identifier)
    msg.value       // (uint) number of wei sent with the message


    // TRANSACTION

    tx.gasprice     // (uint) Gas price of the transaction
    tx.origin       // (address) Sender of the transaction (full call chain)


    // CONTRACT

    this.selfdestruct(address recipient) // destroy the current contract, sending its funds to the given Address


    // OTHER

    gasleft()                   // returns (uint256) Remaining gas
    blockhash(uint blockNumber) // returns (bytes32) Hash of the given block - only works for 256 most recent, excluding current, blocks

}