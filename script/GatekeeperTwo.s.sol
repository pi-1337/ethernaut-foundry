// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { GatekeeperTwo } from "../src/GatekeeperTwo.sol";

contract Tester {

    Victim public instance;

    constructor (Victim _instance) {
        instance = _instance;
    }

    function call() external returns (uint256) {
        return instance.func();
    }

}

contract Victim {

    function func() public returns (uint256) {
        uint256 x;
        assembly {
            x := extcodesize(caller())
        }
        return x;
    }
}

contract GatekeeperTwoSolver is Script {

    GatekeeperTwo public instance = GatekeeperTwo(0x63254338599ec40Bb12485072A1968d414B78cb2);

	uint256 prv = vm.envUint("PRV");
	address pub = vm.envAddress("PUB");

    function run() external {
        
        vm.startBroadcast(prv);
        
        Victim v = new Victim();
        Tester t = new Tester(v);

        console.log(address(uint160(t.call())));
        console.log(address(uint160(v.func())));




        vm.stopBroadcast();

    }

}

