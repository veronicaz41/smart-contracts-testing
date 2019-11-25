// From https://github.com/crytic/echidna/blob/master/examples/solidity/truffle/metacoin/contracts/MetaCoinEchidna.sol

pragma solidity ^0.5.0;

import "./MetaCoin.sol";

contract Test is MetaCoin {
    function mint(uint256 ammount) public {
        balances[msg.sender] = ammount;
    }

    // Use echidna to detect overflow
    function echidna_convert() public view returns (bool) {
        return getBalanceInEth(msg.sender) >= getBalance(msg.sender);
    }
}
