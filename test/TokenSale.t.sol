// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from 'forge-std/Test.sol';
import { TokenSale, ExploitContract } from '../src/TokenSale.sol';

import { console } from 'forge-std/console.sol';

interface IToken {
  function balanceOf(address owner) external view returns (uint256);
}

contract TokenSaleTest is Test {
  TokenSale public tokenSale;
  ExploitContract public exploitContract;

  function setUp() public {
    // Deploy contracts
    tokenSale = (new TokenSale){ value: 1 ether }();
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
    assertTrue(tokenSale.isComplete(), 'Challenge Incomplete');
  }

  receive() external payable {}
}
