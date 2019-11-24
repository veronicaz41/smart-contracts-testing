// From https://github.com/sigp/solidity-security-blog
// Block time manipulation

// block.timestamp or its alias now can be manipulated by miners if they have some incentive to do so.
// Fix: use block.number and an average block time to estimate times

pragma solidity ^0.5.0;

contract Roulette {
    uint256 public pastBlockTime; // Forces one bet per block

    constructor() public payable {} // initially fund contract

    // fallback function used to make a bet
    function() external payable {
        require(msg.value == 10 ether); // must send 10 ether to play
        require(now != pastBlockTime); // only 1 transaction per block
        pastBlockTime = now;
        if (now % 15 == 0) {
            // winner
            msg.sender.transfer(address(this).balance);
        }
    }
}
