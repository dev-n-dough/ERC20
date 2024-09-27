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

        // msg.sender is the one who created the token, so he was given 1000 ether
        // now i want to send Bob 100 ether , so make the msg.sender do it(only he has Ourtokens as of now)

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

        assertEq(token.balanceOf(alice), transferAmount);
        assertEq(token.balanceOf(bob) , STARTING_BALANCE - transferAmount);
    }

    function testInitialSupply() public  view{
        uint256 expectedSupply = deployer.INITIAL_SUPPLY();
        assertEq(token.totalSupply(), expectedSupply);
    }

    function testTokenNameAndSymbol() public view {
        assertEq(token.name(), "OurToken");
        assertEq(token.symbol(), "OT");
        // assert(token.symbol() == "OT"); this gives error but the above one doesnt
    }

    function testTransfer() public {
        uint256 transferAmount = 500 ether;
        vm.prank(bob);
        bool success = token.transfer(alice, transferAmount);
        
        assertTrue(success);
        assertEq(token.balanceOf(alice), transferAmount);
        assertEq(token.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
    function testFailTransferInsufficientBalance() public {
        uint256 excessiveAmount = STARTING_BALANCE + 1 ether;
        vm.prank(bob);
        token.transfer(alice, excessiveAmount);
    }

    function testApproveAndAllowance() public {
        uint256 approvalAmount = 1000 ether;
        vm.prank(bob);
        bool success = token.approve(alice, approvalAmount);
        
        assertTrue(success);
        assertEq(token.allowance(bob, alice), approvalAmount); // assert that bob allowed alice for approvalAmount
    }

    function testFailTransferFromInsufficientAllowance() public{
        vm.prank(bob);
        token.approve(alice , 10 ether);

        vm.prank(alice);
        token.transferFrom(bob,alice, 25 ether);
    }
}