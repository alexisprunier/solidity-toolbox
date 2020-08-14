pragma solidity ^0.5.9; 

contract DataTypes {


	// DATA TYPES
    
    string public name = "John";

    int public amount = 10;		// "int" is an alias for uint256
    uint public amount = 10;	// "uint" is an alias for uint256
    uint8 public amount = 10;
    uint256 public amount = 10;
    uint132 public amount = 10;	// the number of unsigned bits for the integer can be choosen

    bool public isSent = true;
    

    // VARIABLE TYPES

	// the variables cannot be modified after the contract has been constructed
    // the value has to be fixed at compile-time
    uint constant minBid = 1000;	

    // the variables cannot be modified after the contract has been constructed
    // it can still be assigned at construction time
    uint immutable minBid = 1000;	


    // VARIABLE VISIBILITY

    string public name;
    string private name;
    string protected name;
    string static name;

    // NOTE: the default visibility is "private"


    // ARRAY

    uint[] count;
    count[0] = 1
    count[1] = 2
    uint selectedInt = count[0]

    // MAPPING
    
    mapping(address => uint) public userLevel;

    userLevel[firstAddress] = 4
    uint selectedLevel = userLevel[firstAddress]


    // STRUCTURE

    struct customer {
        uint idNum;
        string name;
        uint amount;
    }

    // ENUM

    enum Stage {Init, Reg, Vote, Done}
    Stage public stage
    stage = Stage.Init

    if (stage == Stage.Init) {
        stage = Stage.Reg
    }

}