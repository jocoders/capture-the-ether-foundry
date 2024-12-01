// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {GuessTheSecretNumber, ExploitContract} from "../src/GuessTheSecretNumber.sol";

/**
 * @title GuessTheSecretNumber Attack Test
 * @notice Demonstrates exploitation of predictable hash-based number guessing
 *
 * @dev The vulnerability exists because:
 * - Contract uses a static hash of a number for verification
 * - Solidity allows iterating over all possible uint8 values to find the matching hash
 *
 * Attack flow:
 * 1. ExploitContract iterates over all uint8 values
 * 2. Compares hashes until it finds a match with the stored hash
 * 3. Calls guess() with the correct number
 */
contract GuessSecretNumberTest is Test {
    ExploitContract exploitContract;
    GuessTheSecretNumber guessTheSecretNumber;

    function setUp() public {
        // Deploy "GuessTheSecretNumber" contract and deposit one ether into it
        guessTheSecretNumber = (new GuessTheSecretNumber){value: 1 ether}();

        // Deploy "ExploitContract"
        exploitContract = new ExploitContract();
    }

    function testFindSecretNumber() public {
        // Put solution here
        uint8 secretNumber = exploitContract.Exploiter();
        _checkSolved(secretNumber);
    }

    function _checkSolved(uint8 _secretNumber) internal {
        assertTrue(guessTheSecretNumber.guess{value: 1 ether}(_secretNumber), "Wrong Number");
        assertTrue(guessTheSecretNumber.isComplete(), "Challenge Incomplete");
    }

    receive() external payable {}
}
