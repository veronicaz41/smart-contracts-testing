// From https://github.com/sigp/solidity-security-blog
// Fixed the Re-Entrancy vulneravility
// 1. user transfer()
// 2. finish all internal work (ie. state changes) first before calling extenral functions
// 3. can also use mutex, but need to be very careful about deadlocks nad livelocks
//    can use OpenZepplin's ReentrancyGuard nonReentrant modifier

pragma solidity ^0.5.0;

contract EtherStoreFixed {
    mapping(address => uint256) private userBalances;

    function withdrawBalance() external {
        uint256 amountToWithdraw = userBalances[msg.sender];
        // finish all internal work first
        userBalances[msg.sender] = 0;
        // use transfer(), limit gas (2300)
        msg.sender.transfer(amountToWithdraw);
    }
}
