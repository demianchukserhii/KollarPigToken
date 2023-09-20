// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract KollarPigToken {

    string public name = "KollarPigToken";
    string public symbol = "KPT";
    uint8 public decimals = 18;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    uint256 public totalSupply;
    uint256 private constant initialSupply = 100000000000 * 10 ** 18;  // З урахуванням decimals

    bool private stopped = false;

    address private owner;

    modifier ownerOnly {
        require(owner == msg.sender, "Not the contract owner");
        _;
    }

    modifier isRunning {
        require(!stopped, "Contract is stopped");
        _;
    }

    modifier validAddress {
        require(msg.sender != address(0), "Invalid address");
        _;
    }

    constructor() {
        owner = msg.sender;
        totalSupply = initialSupply;
        balanceOf[owner] = totalSupply;
    }

    function transfer(address _to, uint256 _value) isRunning validAddress public returns (bool success) {
        require(_to != address(0), "Zero address not allowed");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress public returns (bool success) {
        require(_to != address(0), "Zero address not allowed");

        balanceOf[_from] -= _value;
        allowance[_from][msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) isRunning validAddress public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function stop() ownerOnly public {
        stopped = true;
    }

    function start() ownerOnly public {
        stopped = false;
    }

    function burn(uint256 _value) isRunning validAddress public {
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        emit Burn(msg.sender, _value);
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed _from, uint256 _value);
}

