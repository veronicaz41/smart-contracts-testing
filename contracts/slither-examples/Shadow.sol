// From https://github.com/crytic/slither/wiki/Detector-Documentation
// State variable shadowing

pragma solidity ^0.5.0;

contract BaseContract {
    address owner;

    // the owner is never assigned, and this modifier does not work
    modifier isOwner() {
        require(owner == msg.sender);
        _;
    }

}

contract DerivedContract is BaseContract {
    // shadowing the owner in BaseContract, should be removed
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function withdraw() external isOwner() {
        msg.sender.transfer(address(this).balance);
    }
}
