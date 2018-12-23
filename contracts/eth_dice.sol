pragma solidity ^0.5.2;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract Dice is usingOraclize {

    uint public gamesPlayed;
    uint public gamesWon;
    
    event PlayerBetAccepted(address _contract, address _player, uint[] _numbers, uint _bet);
    event DiceRolled(address _contract, address _player, uint _winning_number);
    event WinningNumber(address _contract, uint _winning_number);
    event PlayerWins(address _contract, address _winner, uint _winning_number);
    event Cashout(address _contract, address _winner, uint _winning_number, uint _winning_amount);

    constructor() 
        public
    {
        gamesPlayed = 0;
        gamesWon = 0;
    }

    function rollDice(uint[] memory betNumbers)
        public 
        payable 
        returns(uint, uint) 
    {

        bool playerWins;
        emit PlayerBetAccepted(address(this), msg.sender, betNumbers, msg.value);
    
        uint winningAmount;
        uint winningNumber = this.numberGenerator();

        for (uint i = 0; i < betNumbers.length; i++) {

            uint betNumber = betNumbers[i];

            if(betNumber == winningNumber) {
                playerWins = true;
                emit PlayerWins(address(this), msg.sender, winningNumber);

            }

        }

        if(playerWins) {

            if(betNumbers.length == 1) {
                    winningAmount = (msg.value * 588) / 100;
            }
            if(betNumbers.length == 2) {
                    winningAmount = (msg.value * 293) / 100;
            }
            if(betNumbers.length == 3) {
                    winningAmount = (msg.value * 195) / 100;
            }
            if(betNumbers.length == 4) {
                    winningAmount = (msg.value * 142) / 100;
            }
            if(betNumbers.length == 5) {
                    winningAmount = (msg.value * 107) / 100;
            }
            if(betNumbers.length == 6) {
                    winningAmount = msg.value;
            }

            msg.sender.transfer(winningAmount);
            
            emit Cashout(address(this), msg.sender, winningNumber, winningAmount);
            gamesWon += 1;

        }

        gamesPlayed += 1;
        return (winningNumber, winningAmount);
    }

    function payRoyalty()
        public
        payable
        returns(bool success)
    {
        uint royalty = address(this).balance/2;
        address payable royalty1 = 0x661599a312f340a6450B05690c715f0b827dc570;
        address payable royalty2 = 0x661599a312f340a6450B05690c715f0b827dc570;
        royalty1.transfer(royalty/2);
        royalty2.transfer(royalty/2);
        return (true);
    }
    
    function numberGenerator()
        public
        returns(uint)
    {
        // XXX TODO function to call random.org for a random number from 1 to 6
        uint winningNumber = 7; 
        emit WinningNumber(address(this), winningNumber);
        return (winningNumber);
    }

    function getBlockTimestamp()
        public
        view
        returns (uint)
    {
        return (now);
    }

    function getContractBalance()
        public
        view
        returns (uint)
    {
        return (address(this).balance);
    }
    
    function _testDivision(uint _testNumber)
        public
        pure
        returns (uint)
    {
        return (_testNumber*180)/100;
    }

}

