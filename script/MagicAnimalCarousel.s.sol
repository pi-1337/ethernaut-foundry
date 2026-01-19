// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { MagicAnimalCarousel } from "../src/MagicAnimalCarousel.sol";

contract MagicAnimalCarouselSolver is Script {
	
	MagicAnimalCarousel public instance = MagicAnimalCarousel(0x9811D61EF68c2244b80C56D8903AC559d154fBEf);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);

		// encodeAnimalName behaves just like bytes_to_long in python
		console.logBytes32(bytes32(instance.encodeAnimalName("abcdabcdabcd")));
	


		vm.stopBroadcast();


	}

}
