// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { MagicNum } from "../src/MagicNum.sol";

contract Test {

    function test() external returns (uint256) {
        return uint256(1337);
    }

    function anything() external returns (uint256) {
        return uint256(1337);
    }

}

contract MagicNumSolver is Script {

    MagicNum public instance = MagicNum(0x78e1db78532098fdbeDde30e020043E7761285a0);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

    function run() external {
        
        vm.startBroadcast(prv);
        
        // in solidity
        // return 42

        // in solidity asm
        // PUSH1 0x2A  (42 in hex)
        // PUSH1 0x00  (offset in memory where MSTORE can put 42 in)
        // MSTORE
        // PUSH1 32    (size to return in bytes)
        // PUSH1 000 (offset in memory where RETURN can return size of bytes)
        // RETURN
        
        // in Raw byte code
        // PUSH1 ---> 0x60
        // MSTORE ---> 0x52
        // RETURN ---> 0xF3

        // Final Raw byte code
        // 602A60775260206077F3

        // we are still not done how about contract creation
        // 69 602A60775260206077F3 600052600a6016f3
        // 0x69602A60775260206077F3600052600a6016f3


        // deploying the contract

        bytes memory RawBytesCode = hex"69602A60775260206077F3600052600a6016f3";
        
        address mySolver;

        assembly {
            mySolver := create(0, add(RawBytesCode, 0x20), mload(RawBytesCode))
        }

        instance.setSolver(mySolver);
        console.log(address(uint160(Test(mySolver).test())));
        // 0x000000000000000000000000000000000000002A
        console.log(address(uint160(Test(mySolver).anything())));
        // 0x000000000000000000000000000000000000002A

        vm.stopBroadcast();

    }

}

