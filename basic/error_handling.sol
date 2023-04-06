pragma solidity ^0.5.9; 

contract ErrorHandling {

	// invalidates the transaction if the condition is not met - to be used for internal errors.
	// assert(bool condition) 

	assert(1 == 1)
	assert(1 == 2)

	// reverts if the condition is not met - to be used for errors in inputs or external components.
	// require(bool condition) 

	require(1 == 1) 

	// reverts if the condition is not met - to be used for errors in inputs or external components. Also provides an error message.
	// require(bool condition, string message) 

	require(1 == 1, "Those are not equal") 

	// abort execution and revert state changes
	// revert() 

	revert() 

	// abort execution and revert state changes, providing an explanatory string
	// revert(string reason) 

	revert("Integer us too big") 

}