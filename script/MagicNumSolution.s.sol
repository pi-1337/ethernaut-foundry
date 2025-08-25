// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/MagicNum.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract MagicNumSolution is Script {

    // Replace with the deployed MagicNum address
    MagicNum public magicNumInstance = MagicNum(0x62fe3F4c24fa91EF10D0F36b81a37d0474d349F8);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        // // Tiny runtime bytecode: returns 42
        // bytes memory initCode = hex"600a600c600039600a6000f3602a60005260206000f3";

        // address solver;
        // assembly {
        //     solver := create(0, add(initCode, 0x20), mload(initCode))
        // }

        // console.log("Solver deployed at:", solver);

        // Set the solver in the MagicNum contract
        magicNumInstance.setSolver(0xB5094f4A5F4373C350f6d60E81fc04F07F01e98e);


        vm.stopBroadcast();
    }
}
