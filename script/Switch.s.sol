// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Switch } from "../src/Switch.sol";



contract SwitchSolver is Script {
	
	// Switch public instance = Switch(0x9CA90eE54Ce749d00eF4D334c2D9C250b5027B04);
	Switch public instance = new Switch();

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);




		vm.stopBroadcast();


	}

}
