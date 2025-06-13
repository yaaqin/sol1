// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract DigitalWalletKampus {
    // storage (main contract)
    mapping(address => uint256) public balances; 
    address public admin;
    

    // event interface contract
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    
    constructor() {
        admin = msg.sender;
    }

    modifier onlyOwner {
        require(admin == msg.sender, "Hanya Admin yang diizinkan");
        _;
    }
    

    // write contract class
    function deposit() public payable {
        require(msg.value > 0, "Amount harus lebih dari 0");

        // msg.value == value yang udah lu input

        balances[msg.sender] += msg.value;
        
        // balances[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] += msg.value

        emit Deposit(msg.sender, msg.value);

        // console.log(msg.sender, msg.value)
    }
    
    // TODO: Implementasikan withdraw function
    function withdraw(uint256 _amount) public payable {
        require(balances[msg.sender] >= _amount); // saldo cukup
        require(_amount > 0); // amount > 0

        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);

        emit Withdrawal(msg.sender, _amount);
    }

    // TODO: Implementasikan transfer function 
    function transfer(address _to, uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Saldo tidak mencukupi");
        require(_amount > 0, "Amount harus lebih dari 0"); 
        require(_to != msg.sender, "Tidak bisa transfer ke wallet sendiri");

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
    }

    // TODO: Tambahkan access control (wallet user di withdraw oleh admin)
    function emergencyWithdraw(address _user, uint256 _amount) public  onlyOwner {
        require(balances[_user] >= _amount, "Saldo tidak mencukupi");

        balances[_user] -= _amount;

        payable(admin).transfer(_amount);

        emit Withdrawal(_user, _amount);

    }

}