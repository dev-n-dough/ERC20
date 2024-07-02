// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract TestOurToken is Test
{
    OurToken public token;
    DeployOurToken public deployer;

    address bob = address(6);
    address alice = address(9); // nice

    uint256 public constant STARTING_BALANCE = 2000 ether;
    function setUp() public
    {
        deployer = new DeployOurToken();
        token = deployer.run();

        vm.prank(msg.sender);
        token.transfer(bob,STARTING_BALANCE);
    }

    function testBobBalance() public view
    {
        assert(STARTING_BALANCE == token.balanceOf(bob));
    }
    function testAllowanceWorks() public
    {
        uint256 initialAllowance = 1000 ether;
        vm.prank(bob);
        token.approve(alice,initialAllowance);

        uint256 transferAmount = 500 ether;
        vm.prank(alice);
        token.transferFrom(bob,alice,transferAmount);

        // assertEq(token.balanceOf(alice), transferAmount);
        // assertEq(token.balanceOf(bob) , STARTING_BALANCE - transferAmount);
    }
}