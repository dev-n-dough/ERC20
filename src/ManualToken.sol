//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract ManualToken 
{

    mapping(address => uint256) s_balances;

    function name() public pure returns (string memory)
    {
        return "Manual Token";
    }

    function decimals() public pure returns (uint8)
    {
        return 18;
    }
    function totalSupply() public pure returns (uint256)
    {
        return 100 ether;
    }
    function balanceOf(address _owner) public view returns (uint256 balance)
    {
        return s_balances[_owner];
    }
    function transfer(address _to, uint256 _value) public returns (bool success)
    {
        uint256 initialBalances = s_balances[msg.sender] + s_balances[_to];
        s_balances[msg.sender] -= _value;
        s_balances[_to] += _value;
        success = s_balances[msg.sender] + s_balances[_to] == initialBalances;
    }


}