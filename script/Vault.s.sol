// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Vault} from "../src/vault.sol";
import {FathonToken} from "../src/Fathon.sol";

contract VaultScript is Script {
    Vault public vault;
    FathonToken public fathonToken;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        fathonToken = new FathonToken();

        console.log("FathonToken deployed at:", address(fathonToken));

        vault = new Vault(address(fathonToken));
        console.log("Vault deployed at:", address(vault));

        vm.stopBroadcast();
    }
}

// RUN -> broadcast, verify
// forge script script/Vault.s.sol --rpc-url $RPC_URL --broadcast -vvv --verify --etherscan-api-key $ETHERSCAN_API_KEY

// DRY RUN -> no broadcast & verify
// forge script script/Vault.s.sol --rpc-url $RPC_URL -vvv

