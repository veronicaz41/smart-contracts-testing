// From https://swcregistry.io/docs/SWC-112
// Delegatecall to Untrusted Callee

// Calling into untrusted contracts is very dangerous, as the code at the target address can change any storage values of the caller and has full control over the caller's balance.

pragma solidity ^0.5.0;

contract Proxy {
    address private owner;

    constructor() public {
        owner = msg.sender;
    }

    function forward(address callee, bytes memory _data) public {
        (bool success, ) = callee.delegatecall(_data);
        require(success);
    }

}
