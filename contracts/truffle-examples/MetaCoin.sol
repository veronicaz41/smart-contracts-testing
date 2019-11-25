// From https://github.com/truffle-box/metacoin-box

pragma solidity ^0.5.0;

import "./ConvertLib.sol";

contract MetaCoin {
    mapping(address => uint256) private balances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    constructor(address owner) public {
        balances[owner] = 10000;
    }

    function sendCoin(address receiver, uint256 amount)
        public
        returns (bool sufficient)
    {
        require(
            balances[msg.sender] >= amount,
            "SendCoin: amount exceeds account balance"
        );
        balances[msg.sender] -= amount;
        // overflow?
        balances[receiver] += amount;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    function getBalanceInEth(address addr) public view returns (uint256) {
        return ConvertLib.convert(getBalance(addr), 2);
    }

    function getBalance(address addr) public view returns (uint256) {
        return balances[addr];
    }
}
