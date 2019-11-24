// From https://github.com/crytic/slither/wiki/Detector-Documentation
// Unprotected call to function executing selfdestruct / suicide

pragma solidity ^0.5.0;

contract Suicidal {
    function kill() external {
        selfdestruct(msg.sender);
    }
}
