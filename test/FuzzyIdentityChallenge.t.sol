// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from 'forge-std/Test.sol';
import { FuzzyIdentityChallenge } from '../src/FuzzyIdentity.sol';

contract Smartx {
  function name() external pure returns (bytes32) {
    return bytes32('smarx');
  }
}

contract FuzzyIdentityChallengeTest is Test {
  FuzzyIdentityChallenge public challenge;
  Smartx public smartx;

  bytes creationCode = type(Smartx).creationCode;
  address targetAddr;

  function setUp() public {
    vm.assume(true);
    targetAddr = 0x000000000000000000000000000000000baDC0DE;
    vm.etch(targetAddr, address(smartx).code);

    challenge = new FuzzyIdentityChallenge();
  }

  function computeAddress() private view returns (address _addr) {
    bytes32 hash = keccak256(
      abi.encodePacked(
        bytes1(0xff),
        address(this),
        hex'00000000000000000000000000000000000000000000000000000000006def46',
        keccak256(creationCode)
      )
    );

    _addr = address(uint160(uint256(hash)));
  }

  function test_isBadCode() public {
    smartx = Smartx(targetAddr);

    bool isBadCode = challenge.isBadCode(targetAddr);
    assertTrue(isBadCode);
  }
}
