// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from 'forge-std/Test.sol';
import { console } from 'forge-std/console.sol';
import { GuessTheSecretNumber, ExploitContract } from '../src/GuessTheSecretNumber.sol';

contract GuessSecretNumberTest is Test {
  ExploitContract exploitContract;
  GuessTheSecretNumber guessTheSecretNumber;

  function setUp() public {
    // Deploy "GuessTheSecretNumber" contract and deposit one ether into it
    guessTheSecretNumber = (new GuessTheSecretNumber){ value: 1 ether }();

    // Deploy "ExploitContract"
    exploitContract = new ExploitContract();
  }

  function testFindSecretNumber() public {
    // Put solution here
    uint8 secretNumber = exploitContract.Exploiter();
    _checkSolved(secretNumber);
  }

  function _checkSolved(uint8 _secretNumber) internal {
    assertTrue(guessTheSecretNumber.guess{ value: 1 ether }(_secretNumber), 'Wrong Number');
    assertTrue(guessTheSecretNumber.isComplete(), 'Challenge Incomplete');
  }

  receive() external payable {}
}
