// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import {IVoidboundSanctum} from "./IVoidboundSanctum.sol";
library VoidboundMerkle {
    uint256 public constant WORLD_NUM_ELEMENTS = 4;
    uint256 public constant WORLD_TREE_HEIGHT = 3;
    uint256 public constant WORLD_BLADES_INDEX = 3;
    uint256 public constant WORLD_RELICS_INDEX = 2;
    uint256 public constant BLADES_NUM_ELEMENTS = 128;
    uint256 public constant BLADES_TREE_HEIGHT = 8;
    uint256 public constant RELICS_NUM_ELEMENTS = 64;
    uint256 public constant RELICS_TREE_HEIGHT = 7;
    uint256 public constant BLADE_NUM_ELEMENTS = 4;
    uint256 public constant RELIC_BLADE_NUM_ELEMENTS = 7;
    function proveBlade(
        IVoidboundSanctum.Blade memory blade,
        bytes32 root,
        bytes32[] memory proof
    ) internal pure returns (bool) {
        uint256 path = (WORLD_BLADES_INDEX << (BLADES_TREE_HEIGHT - 1)) ^
            blade.id;
        return _merkleProof(root, merkleizeBlade(blade), path, proof);
    }
    function proveRelic(
        IVoidboundSanctum.Relic memory relic,
        bytes32 root,
        bytes32[] memory proof
    ) internal pure returns (bool) {
        uint256 path = (WORLD_RELICS_INDEX << (RELICS_TREE_HEIGHT - 1)) ^
            relic.id;
        return _merkleProof(root, merkleizeRelic(relic), path, proof);
    }
    function merkleizeSanctum(
        string memory sanctumName,
        uint256 clanCount,
        IVoidboundSanctum.Blade[] storage blades,
        IVoidboundSanctum.Relic[] storage relics
    ) internal view returns (bytes32) {
        bytes32[] memory hashed = new bytes32[](WORLD_NUM_ELEMENTS);
        hashed[0] = keccak256(abi.encode(sanctumName));
        hashed[1] = keccak256(abi.encode(clanCount));
        hashed[2] = merkleizeRelics(relics);
        hashed[3] = merkleizeBlades(blades);
        return merkleize(hashed);
    }
    function merkleizeBlades(
        IVoidboundSanctum.Blade[] storage blades
    ) internal view returns (bytes32) {
        bytes32[] memory hashed = new bytes32[](BLADES_NUM_ELEMENTS);
        for (uint256 i; i < blades.length && i < BLADES_NUM_ELEMENTS; i++) {
            hashed[i] = merkleizeBlade(blades[i]);
        }
        return merkleize(hashed);
    }
    function merkleizeRelics(
        IVoidboundSanctum.Relic[] storage relics
    ) internal view returns (bytes32) {
        bytes32[] memory hashed = new bytes32[](RELICS_NUM_ELEMENTS);
        for (uint256 i; i < relics.length; i++) {
            hashed[i] = merkleizeRelic(relics[i]);
        }
        return merkleize(hashed);
    }
    function merkleizeBlade(
        IVoidboundSanctum.Blade memory blade
    ) internal pure returns (bytes32) {
        bytes32[] memory hashed = new bytes32[](BLADE_NUM_ELEMENTS);
        hashed[0] = keccak256(abi.encode(blade.id));
        hashed[1] = keccak256(abi.encode(blade.edge));
        hashed[2] = keccak256(abi.encode(blade.tempo));
        hashed[3] = keccak256(abi.encode(blade.roninId));
        return merkleize(hashed);
    }
    function merkleizeRelic(
        IVoidboundSanctum.Relic memory relic
    ) internal pure returns (bytes32) {
        bytes32[] memory hashed = new bytes32[](RELIC_BLADE_NUM_ELEMENTS);
        hashed[0] = keccak256(abi.encode(relic.id));
        hashed[1] = keccak256(abi.encode(relic.title));
        hashed[2] = keccak256(abi.encode(relic.myth));
        hashed[3] = keccak256(abi.encode(relic.temper));
        hashed[4] = keccak256(abi.encode(relic.attunement));
        hashed[5] = keccak256(abi.encode(relic.sigil));
        hashed[6] = keccak256(abi.encode(relic.isSealed));
        return merkleize(hashed);
    }
    function merkleize(bytes32[] memory input) internal pure returns (bytes32) {
        uint256 n = _upperPow2(input.length);
        bytes32[] memory cache = new bytes32[](n);
        for (uint256 i = 0; i < input.length; i++) {
            cache[i] = input[i];
        }
        n /= 2;
        while (n > 0) {
            for (uint256 i = 0; i < n; i++) {
                (bytes32 l, bytes32 r) = (cache[2 * i], cache[2 * i + 1]);
                if (r == bytes32(0)) {
                    if (l == bytes32(0)) {
                        cache[i] = bytes32(0);
                    } else {
                        cache[i] = keccak256(abi.encodePacked(l, l));
                    }
                } else {
                    cache[i] = keccak256(abi.encodePacked(l, r));
                }
            }
            n /= 2;
        }
        return cache[0];
    }
    function _upperPow2(uint256 n) private pure returns (uint256 x) {
        x = 1;
        while (n > x) {
            x <<= 1;
        }
    }
    function _merkleProof(
        bytes32 root,
        bytes32 leaf,
        uint256 path,
        bytes32[] memory proof
    ) private pure returns (bool) {
        bytes32 hashed = leaf;
        for (uint256 i; i < proof.length; i++) {
            if (path % 2 == 0) {
                hashed = keccak256(abi.encodePacked(hashed, proof[i]));
            } else {
                hashed = keccak256(abi.encodePacked(proof[i], hashed));
            }
            path >>= 1;
        }
        return root == hashed;
    }
}