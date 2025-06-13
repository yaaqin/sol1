// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract DigitalKampus {
    //storage , memory , call data

    mapping(address => uint256) public balances;
    address public admin;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    // constructor() {
    //     admin = msg.sender;
    // }

    address payable public owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    modifier onlyAdmin() {
        require(msg.sender == owner, "Anda tidak punya akses");
        _;
    }

    function deposit() public payable {
        require(msg.value > 0, "Amount harus lebih dari 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Function withdrawal() external payable  returns (uint256) {
    function withdrawal() public payable {
        uint256 balance = msg.value;
        require((balance > 0), "Balance must be greater than zero");
        owner.transfer(balance);
        emit Withdrawal(msg.sender, balance);
    }

    function transfer(address payable _to, uint256 _amount)
        public
        payable
        onlyAdmin
    {
        require((_amount > 10), "minimal kirim 10");
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }

    function viewSaldo() public view returns (uint256) {
        return owner.balance;
    }
}
