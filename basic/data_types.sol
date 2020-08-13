pragma solidity ^0.5.9; 

contract DataTypes {


	// Data types

    
    string public name = "John";

    int public amount = 10;		// "int" is an alias for uint256
    uint public amount = 10;	// "uint" is an alias for uint256
    uint8 public amount = 10;
    uint256 public amount = 10;
    uint132 public amount = 10;	// the number of unsigned bits for the integer can be choosen

    bool public isSent = true;
    



    // Variable types


	// the variables cannot be modified after the contract has been constructed
    // the value has to be fixed at compile-time
    uint constant minBid = 1000;	

    // the variables cannot be modified after the contract has been constructed
    // it can still be assigned at construction time
    uint immutable minBid = 1000;	




    // Variable visibility


    string public name;
    string private name;
    string protected name;
    string static name;

    // NOTE: the default visibility is "private"




    // Setter and Getter

    function setName(string nm) public {
        name = nm;
        
    }
    
    function setAmount(uint x) public {
        amount  = x;
    }

}