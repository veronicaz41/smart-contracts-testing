// From https://github.com/sigp/solidity-security-blog
// Re-Entrancy

pragma solidity ^0.5.0;

contract EtherStore {
    mapping(address => uint256) private userBalances;

    function withdrawBalance() public {
        uint256 amountToWithdraw = userBalances[msg.sender];
        (bool success, ) = msg.sender.call.value(amountToWithdraw)(""); // At this point, the caller's code is executed, and can call withdrawBalance again
        require(success);
        userBalances[msg.sender] = 0;
    }
}
