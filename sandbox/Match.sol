pragma solidity ^0.5.9; 

import "./DCSport.sol";

contract Match {

	// Organization
	DCSport public dcsport;
	
	// Both of the teams competing in the match
    string public opponent1;
    string public opponent2;

    // Time of the match
    uint public time;

    // Initiator of the match
    address public bookmaker;

    // if yes, it is possible to vote for a draw result
    bool public acceptDraw;

    // Status of the betting
    enum Status {INIT, ON_GOING, LOCKED, FINISHED, CANCELLED, DESTROYED}
    Status public status;

    // Bets
    //
    // position 1 : bets for the opponent1
    // position 2 : bets for the opponent2
    // position 3 : bets for draw
    //
    mapping(address => uint)[] public bets;

    // Accepted token in the betting
    DaiToken daiToken;

    // Events
    Event Withdrawal(address receiver, uint amount);
    Event Deposit(address receiver, uint amount);


    constructor(DCSport addr, string _opponent1, string _opponent2, uint _time, bool _acceptDraw) public {

    	// Register the match within the organization
    	dcsport = addr;
    	dcsport.addMatch();

    	// Init attributes
        bookmaker = msg.sender;
        opponent1 = _opponent1;
        opponent2 = _opponent2;
        time = _time;
        acceptDraw = _acceptDraw;
        status = Status.INIT;

        bets.length = acceptDraw ? 3 : 2;

        daiToken = DaiToken(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);
    }

    modifier refereePower() {
    	require (bookmaker == msg.sender)
    	_;
    }
    
    modifier validBet(uint8 position, uint amount) { 
    	require(status == Status.ON_GOING, "The betting is not on going");
    	require(amount > 1, "The minimum value of betting is 1");

    	if (acceptDraw)
    		require(position == 0 || position == 1 || position == 2, "Unknown position");
		else
			require(position == 1 || position == 2, , "Unknown position")

      	_;
    }

    function bet(uint8 position, uint amount) public validBet(position, amount)  {
    	if (block.timestamp > (time - 5 minutes)) {

    	} else {
    		require(daiToken.balanceOf(msg.sender) > amount, "Insufficient balance of DAI");

    		daiToken.transfert(bookmaker, amount)

    		bets[position][msg.sender] = bets[position][msg.sender] + amount;
    	}
    }

    function declareWinner(uint8 position, uint amount) public refereePower {
        if (block.timestamp > time) {



        	status = Status.FINISHED;
        }
    }

    function cancel() public refereePower {
    	status = Status.CANCELLED;
    }
}