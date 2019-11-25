// From https://swcregistry.io/docs/SWC-113
// DoS with Failed Call

pragma solidity ^0.5.0;

contract Refunder {
    address payable[] private refundAddresses;
    mapping(address => uint256) public refunds;

    constructor() public {
        refundAddresses.push(
            address(0x79B483371E87d664cd39491b5F06250165e4b184)
        );
        refundAddresses.push(
            address(0x858B0014BcD3c207A144ef0802c766BCAe5eD3A8)
        );
    }

    // bad
    // Favor pull over push for external calls
    // May also exceed gas limit
    function refundAll() public {
        for (uint256 x; x < refundAddresses.length; x++) {
            // arbitrary length iteration based on how many addresses participated
            require(refundAddresses[x].send(refunds[refundAddresses[x]])); // doubly bad, now a single failure on send will hold up all funds
        }
    }

}
