// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {GuessNewNumber, ExploitContract} from "../src/GuessNewNumber.sol";

/**
 * @title GuessNewNumber Attack Test
 * @notice Demonstrates exploitation of predictable RNG based on block properties
 *
 * @dev The vulnerability exists because:
 * - Contract uses blockhash and block.timestamp to generate a guess number
 * - These values can be predicted if the call is made at the right block and time
 *
 * Attack flow:
 * 1. ExploitContract predicts the number using the same blockhash and timestamp
 * 2. Calls guessNum() which internally calls guess() with the predicted number
 * 3. If the prediction is correct, funds are transferred
 */
contract GuessNewNumberTest is Test {
    GuessNewNumber public guessNewNumber;
    ExploitContract public exploitContract;

    function setUp() public {
        // Deploy contracts
        guessNewNumber = (new GuessNewNumber){value: 1 ether}();
        exploitContract = new ExploitContract();
    }

    function testNumber(uint256 blockNumber, uint256 blockTimestamp) public {
        // Prevent zero inputs
        vm.assume(blockNumber != 0);
        vm.assume(blockTimestamp != 0);
        // Set block number and timestamp
        vm.roll(blockNumber);
        vm.warp(blockTimestamp);

        // Place your solution here
        uint8 answer = exploitContract.guessNum();
        _checkSolved(answer);
    }

    function _checkSolved(uint8 _newNumber) internal {
        assertTrue(guessNewNumber.guess{value: 1 ether}(_newNumber), "Wrong Number");
        assertTrue(guessNewNumber.isComplete(), "Balance is supposed to be zero");
    }

    receive() external payable {}
}
