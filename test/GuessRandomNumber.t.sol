// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {GuessRandomNumber, ExploitContract} from "../src/GuessRandomNumber.sol";

/**
 * @title GuessRandomNumber Attack Test
 * @notice Demonstrates exploitation of predictable RNG based on block properties at contract creation
 *
 * @dev The vulnerability exists because:
 * - Contract uses blockhash and block.timestamp at creation time to set an immutable guess number
 * - These values can be predicted if the call is made at the right block and time
 *
 * Attack flow:
 * 1. ExploitContract predicts the number using the same blockhash and timestamp at its creation
 * 2. Calls exploit() which internally calls guess() with the predicted number
 * 3. If the prediction is correct, funds are transferred
 */
contract GuessRandomNumberTest is Test {
    GuessRandomNumber public guessRandomNumber;
    ExploitContract public exploitContract;

    function setUp() public {
        guessRandomNumber = (new GuessRandomNumber){value: 1 ether}();
        exploitContract = (new ExploitContract){value: 1 ether}(guessRandomNumber);
    }

    function testAnswer(uint256 blockNumber, uint256 blockTimestamp) public {
        // Prevent zero inputs
        vm.assume(blockNumber != 0);
        vm.assume(blockTimestamp != 0);
        // Set block number and timestamp
        vm.roll(blockNumber);
        vm.warp(blockTimestamp);

        // Place your solution here
        exploitContract.exploit();
        _checkSolved();
    }

    function _checkSolved() public view {
        assertTrue(guessRandomNumber.isComplete(), "Wrong Number");
    }

    receive() external payable {}
}
