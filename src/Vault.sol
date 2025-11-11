// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
//Buat import ERC20 template

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
//Interface ERC20
import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
//Agar bisa diown oleh owner

contract Vault is ERC20, Ownable {
    address public assetToken;

    error AmountCannotBeZero();

    // --- Events (Must be defined) ---
    event Deposit(address indexed sender, uint256 amount, uint256 shares);
    event Withdraw(address indexed sender, uint256 amount, uint256 shares);

    constructor(address _assetToken) ERC20("Vault", "VAULT") Ownable(msg.sender) {
        assetToken = _assetToken;
    }

    //fungsi deposit biar bisa deposit
    function deposit(uint256 amount) external{
        //biar gabisa zero
        //jika amount adalah 0, maka revert
        if(amount == 0) revert AmountCannotBeZero();

        uint256 totalAssets = IERC20(assetToken).balanceOf(address(this));
        uint256 shares =0;

        if(totalSupply() == 0){
            shares = amount;
        } else{
            //jika totalSupply tidak 0, maka shares adalah amount * totalSupply / totalAssets
            shares = amount * totalSupply() / totalAssets;
        }

        //mint shares ke msg.sender
        _mint(msg.sender, shares);

        //transfer amount dari msg.sender ke address(this)
        IERC20(assetToken).transferFrom(msg.sender, address(this), amount);
        emit Deposit(msg.sender, amount, shares);
    }


    function withdraw(uint256 shares) external{
        uint256 totalAssets = IERC20(assetToken).balanceOf(address(this));
        uint256 amount = (shares * totalAssets) / totalSupply();

        _burn(msg.sender, shares);
        IERC20(assetToken).transfer(msg.sender, amount);

        emit Withdraw(msg.sender, amount, shares);
    }

    //fungsi distribute yield biar bisa didistribusikan hanya oleh owner atau pemilik smartContract
    function distributeYield(uint256 amount) external onlyOwner{
        IERC20(assetToken).transferFrom(msg.sender, address(this), amount);
    }
}
