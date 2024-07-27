// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Script} from "forge-std/Script.sol";
import {DeployOurToken} from "../../script/DeployOurToken.s.sol";
import {OurToken} from "../../src/OurToken.sol";

contract OurTokenTest is Test {
    uint256 public initialSupply;
    OurToken private ourToken;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant INITIAL_TOKEN = 100 ether;

    // deploy
    function setUp() external {
        DeployOurToken deploy = new DeployOurToken();
        ourToken = deploy.run();
        initialSupply = deploy.INITIAL_SUPPLY();

        vm.prank(msg.sender);
        console.log(msg.sender);
        ourToken.transfer(bob, 100 ether);
    }

    function testBobToken() public view {
        assertEq(INITIAL_TOKEN, ourToken.balanceOf(bob));
    }

    function testTransfer() public {
        uint256 transferAmount = 100 * 10 ** ourToken.decimals();
        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);

        assertEq(ourToken.balanceOf(bob), INITIAL_TOKEN - transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
    }

    function testTransferExceedingBalance() public {
        uint256 transferAmount = 2000 * 10 ** ourToken.decimals();
        vm.prank(bob);
        vm.expectRevert();
        ourToken.transfer(alice, transferAmount);
    }

    function testApproveAndTransferFrom() public {
        uint256 approveAmount = 100 * 10 ** ourToken.decimals();
        uint256 transferAmount = 50 * 10 ** ourToken.decimals();

        vm.prank(bob);
        ourToken.approve(alice, approveAmount);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(bob), INITIAL_TOKEN - transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(
            ourToken.allowance(bob, alice),
            approveAmount - transferAmount
        );
    }
}
