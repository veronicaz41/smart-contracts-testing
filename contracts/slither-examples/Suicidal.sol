// From https://github.com/crytic/slither/wiki/Detector-Documentation
// Unprotected call to function executing selfdestruct / suicide

pragma solidity ^0.5.0;

contract Suicidal {
    constructor() public payable {}

    function kill() public {
        selfdestruct(msg.sender);
    }
}
