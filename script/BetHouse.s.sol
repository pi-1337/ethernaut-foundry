// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { BetHouse, Pool, PoolToken } from "../src/BetHouse.sol";


contract BetHouseSolver is Script {
	
	// BetHouse public instance = BetHouse();
	PoolToken pt1 = new PoolToken("name1", "NM1");
	PoolToken pt2 = new PoolToken("name2", "NM2");
	Pool pool = new Pool(address(pt1), address(pt2));
	BetHouse public instance = new BetHouse(address(pool));
	
	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);

		console.log(address(pool));

		vm.stopBroadcast();


	}

}
