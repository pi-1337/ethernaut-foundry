
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Dex.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract DexSolution is Script {

    Dex public DexInstance = Dex(0x9F5554C108a575b9235714A007aA967ba122d84D);

    address my_addr = vm.envAddress("PUBLIC_KEY");
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address token1=DexInstance.token1();
        address token2=DexInstance.token2();
        // uint256 x = DexInstance.getSwapPrice(token1, token2, 1);
        uint256 amount = DexInstance.balanceOf(token1, my_addr);
        DexInstance.approve(my_addr, amount);


        // DexInstance.swap(token1, token2, amount);
        
        // amount = DexInstance.balanceOf(token1, my_addr);
        // console.log(amount);

        vm.stopBroadcast();
    }
}