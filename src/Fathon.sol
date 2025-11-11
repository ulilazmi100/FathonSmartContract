// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
//Buat import ERC20 template

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
//Agar bisa diown oleh owner

contract FathonToken is ERC20, Ownable {
    constructor() ERC20("FathonToken", "FATHON") Ownable(msg.sender){} //nama token dan singkatan token

    //Kasih penjelasan berapa banyak token yang bisa dicetak

    function mint(address to, uint256 amount) public {
        _mint(to, amount); 
        //mint ke siapa amount berapa
        //buat ngilangin onlyOwner biar functionnya yang asli yang ada onlyOWnernya ilang
    }

    function burn(address from, uint256 amount) public{
        _burn(from, amount);
    }
}
