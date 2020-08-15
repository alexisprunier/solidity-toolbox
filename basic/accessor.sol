pragma solidity ^0.5.9; 

contract Accessor {

	// The getter functions are automatically generated for public variables
    
    string public name = "John";
    int public amount = 10;
        
    function setName(string nm) public {
        name = nm;
        
    }
    
    function setAmount(uint x) public {
        amount  = x;
    }

}