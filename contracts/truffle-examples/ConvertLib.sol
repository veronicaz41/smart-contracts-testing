// From https://github.com/truffle-box/metacoin-box
// Overflow

pragma solidity ^0.5.0;

library ConvertLib {
    function convert(uint256 amount, uint256 conversionRate)
        public
        pure
        returns (uint256 convertedAmount)
    {
        // overflow
        return amount * conversionRate;
    }
}
