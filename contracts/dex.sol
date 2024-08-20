// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

// Import the ERC20 interface
interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract SimpleSwap {
    address public token1;
    address public token2;
    uint256 public rate; // rate represents how many token2 units are given per token1 unit

    constructor(address _token1, address _token2, uint256 _rate) {
        token1 = _token1;
        token2 = _token2;
        rate = _rate;
    }

    function swap(uint256 _amount) public {
        // Calculate the amount of token2 the user will receive
        uint256 amountToReceive = _amount * rate;

        // Ensure the contract has enough token2 to complete the swap
        require(IERC20(token2).balanceOf(address(this)) >= amountToReceive, "Insufficient token2 balance in contract");

        // Transfer token1 from the user to the contract
        require(IERC20(token1).transferFrom(msg.sender, address(this), _amount), "Token1 transfer failed");

        // Transfer token2 from the contract to the user
        require(IERC20(token2).transfer(msg.sender, amountToReceive), "Token2 transfer failed");
    }
}