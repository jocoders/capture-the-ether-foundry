# Capture The Ether - Foundry Edition

## Overview

This project is a comprehensive suite of challenges and solutions based on the popular Ethereum game, Capture The Ether. It is designed to test and enhance your understanding of various security vulnerabilities and features within Solidity smart contracts. Each challenge is a self-contained contract that represents a specific security scenario, and the accompanying exploit contracts demonstrate how these vulnerabilities can be exploited.

## Challenges and Solutions

### 1. GuessNewNumber

- **Contract**: `GuessNewNumber.sol`
- **Description**: This challenge involves guessing a number that is derived from the blockhash and timestamp of the previous block.
- **Exploit**: The exploit contract calculates the correct number using the same method as the challenge contract and submits the guess.

### 2. GuessRandomNumber

- **Contract**: `GuessRandomNumber.sol`
- **Description**: Similar to GuessNewNumber, but the number to guess is set at contract deployment and remains constant.
- **Exploit**: The exploit contract retrieves the number during its deployment and uses it to guess correctly.

### 3. GuessTheSecretNumber

- **Contract**: `GuessTheSecretNumber.sol`
- **Description**: This challenge requires guessing a number that hashes to a specific value.
- **Exploit**: The exploit iterates through all possible numbers to find the one that matches the hash.

### 4. PredictTheBlockhash

- **Contract**: `PredictTheBlockhash.sol`
- **Description**: Predict the blockhash of a future block.
- **Exploit**: The exploit contract makes a guess based on the current blockhash.

### 5. PredictTheFuture

- **Contract**: `PredictTheFuture.sol`
- **Description**: Guess a number that will match a future pseudorandom number derived from blockhash and timestamp.
- **Exploit**: The exploit monitors the blockchain to make a correct guess when conditions are favorable.

### 6. RetirementFund

- **Contract**: `RetirementFund.sol`
- **Description**: Withdraw funds from a contract without waiting for a time lock.
- **Exploit**: The exploit uses a self-destruct mechanism to bypass the time lock and claim the funds.

### 7. TokenBank

- **Contract**: `TokenBank.sol`
- **Description**: Exploit a reentrancy vulnerability in a token bank contract.
- **Exploit**: The exploit contract uses a callback from a malicious token to reenter the bank contract and drain its funds.

### 8. TokenSale

- **Contract**: `TokenSale.sol`
- **Description**: Exploit integer overflow in a token sale contract.
- **Exploit**: The exploit makes a purchase with an amount of ether that causes an overflow, allowing for nearly free tokens.

### 9. TokenWhale

- **Contract**: `TokenWhale.sol`
- **Description**: Manipulate token balances to become a token whale.
- **Exploit**: The exploit abuses poor access control to increase its token balance.

## Usage

To run any of these challenges and their exploits:

1. Deploy the challenge contract using Foundry.
2. Deploy the corresponding exploit contract.
3. Execute the exploit function to attempt to solve the challenge.

## Conclusion

This project serves as an educational tool for Solidity developers to understand and mitigate common security vulnerabilities in smart contracts. By working through these challenges, developers can gain practical experience in both identifying and exploiting contract vulnerabilities.
