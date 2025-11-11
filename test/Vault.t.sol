// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";
import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20{
    constructor() ERC20("MockERC20", "MOCK"){}

    function mint(address to, uint256 amount) external{
        _mint(to, amount);
    }
}
//unitTest, seakan-akan deploy padahal aslinya juga cuma pengujian doang, saat deploy harus masukin asset token bentuk address
//Nanti token kita deploy dapat deploy masukin construction vault, saat deposit bisa karena dia pakai address yang benar

contract VaultTest is Test {
    
    //bikin seolah-olah user1 dan user2 nanti yang akan melakukan deposit dan Withdraw
    Vault public vault;
    MockERC20 public mockERC20;

    address public user1 = makeAddr("user1");
    address public user2 = makeAddr("user2");

    function setUp() public{
        mockERC20 = new MockERC20();
        vault = new Vault(address(mockERC20)); //masukin address soalnya yang bisa interaksi addressERC20

        mockERC20.mint(user1, 1000);
        mockERC20.mint(user2, 1000);
    }

    function test_Deposit() public {
        vm.startPrank(user1); //seolah-olah jadi user1

        mockERC20.approve(address(vault), 50);

        uint256 beforeBalance = mockERC20.balanceOf(user1);
        
        console.log("Balance before deposit", beforeBalance);

        vault.deposit(50);

        uint256 afterBalance = mockERC20.balanceOf(user1);
        console.log("Balance after deposit", afterBalance);
        vm.stopPrank();
    }

    function test_Withdraw() public {
        vm.startPrank(user1); //seolah-olah jadi user1

        //Pokoknya sebelum transaksi harus approve dulu
        mockERC20.approve(address(vault), 50);

        vault.deposit(50);
        vault.withdraw(50);

        assertEq(vault.totalSupply(), 0);
        assertEq(vault.balanceOf(user1), 0);

        uint256 afterBalance = mockERC20.balanceOf(user1);
        vm.stopPrank();
    }
}
