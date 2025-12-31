// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Privacy } from "../src/Privacy.sol";

contract PrivacySolver is Script {

    Privacy public instance = Privacy(0x55883b0805AED753BC65002fd97BC1059Fa70866);

	uint256 prv = vm.envUint("PRV");
	address pub = vm.envAddress("PUB");

    function run() external {
        vm.startBroadcast(prv);
        
        for (uint256 i = 0; i < 10; i++) {
            bytes32 result = vm.load(address(instance), bytes32(i));
            console.logAddress(address(uint160(uint256(result))));
        }
        // 0xf711f0F25D582d94E8153904412eea4fA00BF3F8
        bytes32 key = vm.load(address(instance), bytes32(uint256(5)));
        instance.unlock(bytes16(key));
        
        for (uint256 i = 0; i < 10; i++) {
            bytes32 result = vm.load(address(instance), bytes32(i));
            console.logAddress(address(uint160(uint256(result))));
        }
        vm.stopBroadcast();
    }

}

