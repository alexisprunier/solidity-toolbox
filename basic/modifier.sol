pragma solidity ^0.5.9; 

contract Modifier {

	// Modifiers can change the behavior of a function. 
	// That's why this feature is referred to as a modifier. 
	// It is also known as a function modifier since it is specified at the entry to a function 
	//		and executed before the execution of the function begins. 
	// You can think of a modifier as a gatekeeper protecting a function. 
	// A modifier typically checks a condition using a require and if the condition failed, 
	//		the transaction that call the function can be reverted using the revert function. 
	// This will completely reject the transaction and revert all its state changes. 
	// There will be no recording on the blockchain.

    enum Stage {Init,Reg, Vote, Done}
    Stage public stage = Stage.Init;
    
    modifier validStage(Stage reqStage) { 
    	require(stage == reqStage);
      	_;
    }

    function vote(uint8 toProposal) public validStage(Stage.Vote)  {
        return;      
    }
}