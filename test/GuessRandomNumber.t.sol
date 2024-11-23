// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from 'forge-std/Test.sol';
import { console } from 'forge-std/console.sol';
import { GuessRandomNumber, ExploitContract } from '../src/GuessRandomNumber.sol';

contract GuessRandomNumberTest is Test {
  GuessRandomNumber public guessRandomNumber;
  ExploitContract public exploitContract;

  function setUp() public {
    guessRandomNumber = (new GuessRandomNumber){ value: 1 ether }();
    exploitContract = (new ExploitContract){ value: 1 ether }(guessRandomNumber);
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
    assertTrue(guessRandomNumber.isComplete(), 'Wrong Number');
  }

  receive() external payable {}
}
