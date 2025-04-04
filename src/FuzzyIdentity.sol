// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// This contract can only be used by me (smarx). I don’t trust myself to remember my private key, so I’ve made it so whatever address I’m using in the future will work:

// I always use a wallet contract that returns “smarx” if you ask its name.
// Everything I write has bad code in it, so my address always includes the hex string badc0de.
// To complete this challenge, steal my identity!
import { Test, console } from 'forge-std/Test.sol';

interface IName {
  function name() external view returns (bytes32);
}

contract FuzzyIdentityChallenge {
  bool public isComplete;

  function authenticate() public {
    require(isSmarx(msg.sender));
    require(isBadCode(msg.sender));

    isComplete = true;
  }

  function isSmarx(address addr) internal view returns (bool) {
    return IName(addr).name() == bytes32('smarx');
  }

  function isBadCode(address _addr) public pure returns (bool) {
    bytes20 addr = bytes20(_addr);
    bytes20 id = hex'000000000000000000000000000000000badc0de';
    bytes20 mask = hex'000000000000000000000000000000000fffffff';

    console.log('_addr', _addr);
    console.logBytes20(addr);

    for (uint256 i = 0; i < 34; i++) {
      console.log('--------------');
      console.logBytes20(addr & mask);
      console.log('--------------');
      if (addr & mask == id) {
        return true;
      }
      mask <<= 4;
      id <<= 4;
    }

    return false;
  }
}
