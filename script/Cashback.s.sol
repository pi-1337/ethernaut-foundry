// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.30;

import {Script, console} from "forge-std/Script.sol";
import { Cashback } from "../src/Cashback.sol";

contract CashbackSolver is Script {
	
	Cashback public instance = new Cashback();

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);


		vm.stopBroadcast();


	}

}
