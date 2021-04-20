pragma solidity ^0.5.0;

import './DappToken.sol';

contract EthSwap {
    string public name = "EthSwap Instant Exchanghe";
    DappToken public token;
    uint public rate = 100;

    event TokensPurchased(
        address account,
        address token,
        uint amount,
        uint rate
    );

    event TokensSold(
        address account,
        address token,
        uint amount,
        uint rate
    );

    constructor(DappToken _token) public {
        token = _token;
    }

    function buyTokens() public payable {
        // Calcur ate the number of tokens to buy
        uint tokenAmount = msg.value * rate;
        
        // require that EthSwap has enough tokens
        require(token.balanceOf(address(this)) >= tokenAmount);

        token.transfer(msg.sender, tokenAmount);

        emit TokensPurchased(msg.sender, address(token), tokenAmount, rate);
    }

    function sellTokens(uint _amount) public {
        // User cant sell more tokens than they
        require(token.balanceOf(msg.sender) >= _amount);
        
        // Calculate the amount of Ether to redeem
        uint etherAmount = _amount / rate;

        // Require
        require(address(this).balance >= etherAmount);

        // Perform sale
        token.transferFrom(msg.sender, address(this), _amount);
        msg.sender.transfer(etherAmount);
        emit TokensSold(msg.sender, address(token), _amount, rate);
    }
}

