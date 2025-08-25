
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Recovery.sol";
import {SimpleToken} from "../src/Recovery.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract RecoverySolution is Script {

    Recovery public recoveryInstance = Recovery(0x167bD1aD88449C88510D1098119D230f3A72b864);
    SimpleToken public simpleToken = SimpleToken(payable(0x3727E8Dc4f04493734BC98999F51A7D55738009D));

    address myAddress = vm.envAddress("PUBLIC_KEY");

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.logString(simpleToken.name());
        simpleToken.destroy(payable(myAddress));

        vm.stopBroadcast();
    }
}
