// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script, console} from "forge-std/Script.sol";
import { ImpersonatorTwo} from "../src/ImpersonatorTwo.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import {ECDSA} from "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract ImpersonatorTwoSolver is Script {

	ImpersonatorTwo public instance = ImpersonatorTwo(0x74be582EC8919233a82fcf51f885eb3fcaF67843);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run() external {
		vm.startBroadcast(prv);

		// I created an instance and went to the explorer https://sepolia.etherscan.io/tx/<TX_HASH>/advanced#internal
		// to see the details of instance creation TX, in order to see the two signatures used for both unlocking and 
		// here are the two signatures


			// Function: switchLock(bytes signature) ***
	
			// MethodID: 0xfd0268fb
			// [0]:  0000000000000000000000000000000000000000000000000000000000000020
			// [1]:  0000000000000000000000000000000000000000000000000000000000000041
			// [2]:  e5648161e95dbf2bfc687b72b745269fa906031e2108118050aba59524a23c40 r
			// [3]:  70026fc30e4e02a15468de57155b080f405bd5b88af05412a9c3217e028537e3 s
			// [4]:  1b00000000000000000000000000000000000000000000000000000000000000 v
			
		
			// Function: setAdmin(bytes domain_,address newAdmin) ***
			
			// MethodID: 0x865fc3f3
			// [0]:  0000000000000000000000000000000000000000000000000000000000000040
			// [1]:  000000000000000000000000ada4affe581d1a31d7f75e1c5a3a98b2d4c40f68
			// [2]:  0000000000000000000000000000000000000000000000000000000000000041
			// [3]:  e5648161e95dbf2bfc687b72b745269fa906031e2108118050aba59524a23c40 r
			// [4]:  4c3ac03b268ae1d2aca1201e8a936adf578a8b95a49986d54de87cd0ccb68a79 s
			// [5]:  1b00000000000000000000000000000000000000000000000000000000000000 v

		// I kept scanning with my eyes, I instantly noticed the disaster, repeated r ???
		// repeated means one thing:
		// 		r = x(k.G)  (where k is the nonce of the signature)
		// for two r's (r1, r2) to be equal means that :
		//              x(k1.G) = x(k2.G)
		// this does not necessarily mean that the nonce is repeated, the two nonce might just be opposites of each other (k1 = -k2 mod (order_of_group))
		// but since the two v's are equal (v1 = v2) this settles it !! the nonces are the same k1 = k2
		// which is a thing you never do in a ECDSA signature, it is a famous security problem in ECDSA (called nonce re-use)

		// if you get nothing from what I am saying then you gonna need to know what ECC or Elliptic Curve Cryptography is.
		// check out https://cryptohack.org/courses/elliptic/course_details/ 
		// cryptohack is a great website and wonderful community on discord.
		
		// Nonce reuse is such a big deal because for different s1 and s2 if r1 = r2, one can efficiently recover the PRIVATE key of the signer
		// meaning the attacker can actually sign ANY transaction in the name of the victim, therefore for example stealing all funds anytime.

		
		// lock
		uint256 r2 = 0xe5648161e95dbf2bfc687b72b745269fa906031e2108118050aba59524a23c40;
		uint256 s2 = 0x70026fc30e4e02a15468de57155b080f405bd5b88af05412a9c3217e028537e3;
		uint256 v2 = 27;

		// setAdmin
		uint256 r1 = 0xe5648161e95dbf2bfc687b72b745269fa906031e2108118050aba59524a23c40;
		uint256 s1 = 0x4c3ac03b268ae1d2aca1201e8a936adf578a8b95a49986d54de87cd0ccb68a79;
		uint256 v1 = 27;


		// recovering the z's

		uint256 nonce = instance.nonce();
        	nonce -= 2;

        	string memory message2 = string(abi.encodePacked("lock", Strings.toString(nonce)));
        	bytes32 z2 = instance.hash_message(message2);

        	nonce++;

        	// address newAdmin = 0xada4affe581d1a31d7f75e1c5a3a98b2d4c40f68; // got from etherscan
        	address newAdmin = instance.admin();
		string memory message1 = string(abi.encodePacked("admin", Strings.toString(nonce), newAdmin));
        	bytes32 z1 = instance.hash_message(message1);

		console.logBytes32(z1);
		console.logBytes32(z2);

		// this is the signing equation :
		// s_i = z_i.k + r.x     where z is the hash of msg being hashed

		// given two such equations where the r and k are repeated :
		// {
		//	s1 = z1.k^-1 + r.x
		//	s2 = z2.k^-1 + r.x
		// }

		// k = (s1 - s2)^{-1} * (z1 - z2) (mod n)    where n is the order of the group
		// also once you know k it is efficient to recover the private key x

		// x = (s1 - z1.k^-1) * r^{-1} (mod n)

		// instead of doing the calculations here, I prefer python3 or sagemath


		// now that we have the private key of the signer, we can do anything, one of them is stealing the funds from the contract:
		// plan is to set my self as the admin, and then unlock funds, these two tasks both need signature forgery
		// after we just withdraw

		// from the script we got this result 
		uint256 victimPrivateKey = 55071432917484091515924500028669976982411586680835345945513091693217834739200;
		victimPrivateKey = 0xbc6905e6bef7f0135a66ee375a3753f34d6cdeb1974534e312d75393bfdfc7dd;
		victimPrivateKey = 0x10a6891de55baf453d66c5faede86eabccf93f3d284540d205f24207670855cc;

		string memory message = string(abi.encodePacked("admin", Strings.toString(instance.nonce()), me));
		(uint8 v, bytes32 r, bytes32 s) = vm.sign(victimPrivateKey, instance.hash_message(message));
		bytes memory forgedSignature = bytes.concat(r, s, bytes1(v));
	
		instance.setAdmin(forgedSignature, me);

		message = string(abi.encodePacked("lock", Strings.toString(instance.nonce())));
		(v, r, s) = vm.sign(victimPrivateKey, instance.hash_message(message));
		forgedSignature = bytes.concat(r, s, bytes1(v));
		instance.switchLock(forgedSignature);
	

		console.logBytes32(bytes32(address(instance).balance));
		instance.withdraw();
		console.logBytes32(bytes32(address(instance).balance));
		
		vm.stopBroadcast();
	}

}

