// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { EllipticToken } from "../src/EllipticToken.sol";

contract EllipticTokenSolver is Script {
	
	EllipticToken public instance = EllipticToken(0xa1c3c8D414536987c8Ef5D0Dac473754dd6b581f);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);



		// console.log(instance.owner());
		// console.logBytes32(bytes32(instance.balanceOf(me)));
		// console.logBytes32(bytes32(instance.balanceOf(aliceAddr)));



		// OWNER SIGNES
		// uint256 amount = 10;
		// address receiver = pubVictim;
		// bytes32 salt = hex"0000000000000000000000000000000000000000000000000000000000000000";

		// (uint8 v1, bytes32 r1, bytes32 s1) = vm.sign(prv, keccak256(abi.encodePacked(amount, receiver, salt)));
		// bytes memory ownerSignature = bytes.concat(bytes32(r1), bytes32(s1), bytes1(v1));

		// (uint8 v2, bytes32 r2, bytes32 s2) = vm.sign(prvVictim, keccak256(abi.encodePacked(amount, receiver, salt)));
		// bytes memory receiverSignature = bytes.concat(bytes32(r2), bytes32(s2), bytes1(v2));



		// instance.redeemVoucher(
		// 	amount,
		// 	receiver,
		// 	salt,
		// 	ownerSignature,
		// 	receiverSignature
		// );


		address aliceAddr = 0xA11CE84AcB91Ac59B0A4E2945C9157eF3Ab17D4e;

		uint256 amount = uint256(keccak256(abi.encodePacked(uint256(10000000000000000000), aliceAddr, hex"04a078de06d9d2ebd86ab2ae9c2b872b26e345d33f988d6d5d875f94e9c8ee1e")));
		address spender = me;


		bytes32 alice_r = hex"ab1dcd2a2a1c697715a62eb6522b7999d04aa952ffa2619988737ee675d9494f";
		bytes32 alice_s = hex"2b50ecce40040bcb29b5a8ca1da875968085f22b7c0a50f29a4851396251de12";
		uint8 alice_v = uint8(0x1c);

		// ab1dcd2a2a1c697715a62eb6522b7999d04aa952ffa2619988737ee675d9494f
		// 2b50ecce40040bcb29b5a8ca1da875968085f22b7c0a50f29a4851396251de12
		// 1c00000000000000000000000000000000000000000000000000000000000000

		uint256 ORDER_OF_GROUP = 115792089237316195423570985008687907852837564279074904382605163141518161494337;

        bytes32 permitAcceptHash = keccak256(abi.encodePacked(aliceAddr, spender, amount));
		(uint8 v2, bytes32 r2, bytes32 s2) = vm.sign(prv, permitAcceptHash);
		bytes memory spenderSignature = bytes.concat(bytes32(r2), bytes32(s2), bytes1(v2));
		
		bytes memory tokenOwnerSignature = bytes.concat(
			bytes32(uint256(alice_r)),
			bytes32(uint256(alice_s)),
			bytes1(alice_v)
		);
		
		instance.permit(amount, spender, tokenOwnerSignature, spenderSignature);


		console.logBytes(bytes.concat(instance.redeemVoucher.selector)); // beb30836

		console.log("||||||| my miserable state before |||||||");
		console.logBytes32(bytes32(instance.balanceOf(me)));
		console.logBytes32(bytes32(instance.balanceOf(aliceAddr)));


		instance.transferFrom(aliceAddr, me, 10000000000000000000);

		console.log("||||||| my rich state after |||||||");
		console.logBytes32(bytes32(instance.balanceOf(me)));
		console.logBytes32(bytes32(instance.balanceOf(aliceAddr)));

		console.log("Thats what you ");


		// from etherscan --> tx --> https://sepolia.etherscan.io/tx/<TX_HASH>/advanced#internal
		// this is the calldata of alice calling redeemVoucher()
		// beb30836
		// 0000000000000000000000000000000000000000000000008ac7230489e80000
		// 000000000000000000000000a11ce84acb91ac59b0a4e2945c9157ef3ab17d4e
		// 04a078de06d9d2ebd86ab2ae9c2b872b26e345d33f988d6d5d875f94e9c8ee1e
		// 00000000000000000000000000000000000000000000000000000000000000a0
		// 0000000000000000000000000000000000000000000000000000000000000120
		// 0000000000000000000000000000000000000000000000000000000000000041
		// 085a4f70d03930425d3d92b19b9d4e37672a9224ee2cd68381a9854bb3673ef8
		// 6b35cfdeee0fb1d2168587fb188eefb4fe046109af063bf85d9d3d6859ceb445
		// 1c00000000000000000000000000000000000000000000000000000000000000
		// 0000000000000000000000000000000000000000000000000000000000000041
		// ab1dcd2a2a1c697715a62eb6522b7999d04aa952ffa2619988737ee675d9494f
		// 2b50ecce40040bcb29b5a8ca1da875968085f22b7c0a50f29a4851396251de12
		// 1c00000000000000000000000000000000000000000000000000000000000000

		vm.stopBroadcast();


	}

}
