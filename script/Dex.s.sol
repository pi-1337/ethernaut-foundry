// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Dex } from "../src/Dex.sol";

contract DexSolver is Script {
	
	Dex public instance = Dex(0x41CE51620da472D575f765F6b5AC96d7Ca7c3f5f);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);



		vm.stopBroadcast();


	}

}
