// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Switch } from "../src/Switch.sol";


contract Test {
    bytes4 public offSelector = bytes4(keccak256("turnSwitchOff()"));

    function test(bytes memory _data) public returns (bytes4) {

        bytes32[1] memory selector;

        assembly {
            calldatacopy(selector, 68, 4) // grab function selector from calldata
        }
        require(selector[0] == offSelector, "Can only call the turnOffSwitch function");


		// return bytes4(selector[0]);

        (bool success,) = address(this).call(_data);
    }

}


contract SwitchSolver is Script {
	
	// Switch public instance = Switch(0x9CA90eE54Ce749d00eF4D334c2D9C250b5027B04);
	Switch public instance = new Switch();
    bytes4 public offSelector = bytes4(keccak256("turnSwitchOff()")); // 543190549 0x20606e15
    bytes4 public onSelector = bytes4(keccak256("turnSwitchOn()")); // 1981971986 0x76227e12

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);




		vm.stopBroadcast();


	}

}
