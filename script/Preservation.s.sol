// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Preservation } from "../src/Preservation.sol";

contract PreservationSolver is Script {

    Preservation public instance = Preservation(0x1e730809B238A0573625f868aceD21f4972F9b3B);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

    function run() external {
        
        vm.startBroadcast(prv);
        
        
        
        vm.stopBroadcast();

    }

}

