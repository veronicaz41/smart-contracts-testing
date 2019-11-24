// From https://github.com/crytic/slither/wiki/Detector-Documentation
// Unused return

pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

contract UnusedReturn {
    using SafeMath for uint256;

    function my_func(uint256 a, uint256 b) public pure {
        // return unused
        a.add(b);
    }
}
