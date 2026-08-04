//SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "forge-std/console.sol";
import {Test} from "../lib/forge-std/src/Test.sol";
import {DotBlockers} from "../src/DotBlockers.sol";

contract DotBlockersTest is Test {
    DotBlockers public dbt;
    address owner = address(this);
    address alice = address(1);
    address bob = address(2);

    uint256 INITIAL_SUPPLY = 100000000000000000000000000;

    function setUp() public {
        dbt = new DotBlockers();
    }

    function testName() public view {
    assertEq(dbt.name(), "Dot Blockers");
    }

    function testSymbol() public view {
    assertEq(dbt.symbol(), "DTB");
    }

    function testTotalSupply() public view {

    assertEq(
        dbt.totalSupply(),
        INITIAL_SUPPLY * 2
    );
    }

    function testMint() public {

    dbt.mint(alice, 100 ether);

    assertEq(
        dbt.balanceOf(alice),
        100 ether
    );
    console.log("Alice's balance after minting:", dbt.balanceOf(alice)/1e18);
    }

    function testBurn() public {

    dbt.burn(owner, 500 ether);

    assertEq(
        dbt.balanceOf(owner),
        INITIAL_SUPPLY - 500 ether
    );
    console.log("Owner's balance after burning:", dbt.balanceOf(owner)/1e18);
    }

    function testReceiveETHReverts() public {
    console.log("alice's balance ETH:", alice.balance/1e18);
    vm.deal(alice, 1 ether);
    console.log("Alice's balance before sending ETH:", alice.balance/1e18);
    vm.prank(alice);
    vm.expectRevert();
    payable(address(dbt)).transfer(1 ether);
    }

    function testTransferFrom() public {
    console.log("bob's balance:", dbt.balanceOf(bob)/1e18);
    console.log("owner balance ETH:", dbt.balanceOf(owner)/1e18);

    dbt.approve(alice, 100 ether);
    vm.prank(alice);
    dbt.transferFrom(owner, bob, 100 ether);
    console.log("bob's after balance:", dbt.balanceOf(bob)/1e18);
    console.log("owner balance:", dbt.balanceOf(owner)/1e18);
    assertEq(
        dbt.balanceOf(bob),
        100 ether
    );
    }

   // Mint Fuzz Test
    function testFuzzMint(address user, uint256 amount) public {
    console.log("user Address:", user);
    console.log("user Amount:", amount);
    console.log("user balance before minting:", dbt.balanceOf(user)/1e18);
    vm.assume(user != address(0));
    amount = bound(amount, 1, 1_000_000 ether);
    dbt.mint(user, amount);
    console.log("user balance after minting:", dbt.balanceOf(user)/1e18);
    assertEq(
        dbt.balanceOf(user),
        amount
    );
    }
}