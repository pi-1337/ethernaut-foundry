// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { AlienCodex } from "../src/AlienCodex.sol";

contract AlienCodexSolver is Script {
	
	AlienCodex public instance = AlienCodex(0x38c2fbc3D1d62AC1349A99AA1fD38861Eb02C8c2);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);



		vm.stopBroadcast();

	}

}
