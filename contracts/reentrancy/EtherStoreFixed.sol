// From https://github.com/sigp/solidity-security-blog
// Fixed the Re-Entrancy vulneravility
// 1. user transfer()
// 2. finish all internal work (ie. state changes) first before calling extenral functions
// 3. can also use mutex, but need to be very careful about deadlocks nad livelocks
//    can use OpenZepplin's ReentrancyGuard nonReentrant modifier

pragma solidity >=0.4.21 <0.6.0;

contract EtherStore {
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        msg.sender.transfer(_weiToWithdraw);
    }
 }