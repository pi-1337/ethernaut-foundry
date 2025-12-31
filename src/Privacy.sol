// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Privacy {
    bool public locked = true;
    uint256 public ID = block.timestamp;
    uint8 private flattening = 10;
    uint8 private denomination = 255;
    uint16 private awkwardness = uint16(block.timestamp);
    bytes32[3] private data;

//   0x0000000000000000000000000000000000000001
//   0x000000000000000000000000000000006953eF44
//   0x00000000000000000000000000000000Ef44ff0A
//   0x1F8ef7AbFA9831f3Cb92C6fDe8dA5E00Da11AEc7
//   0x9D026664FF3c574d091E70dC291D2C727DadB12b
//   0xf711f0F25D582d94E8153904412eea4fA00BF3F8
//   0x0000000000000000000000000000000000000000
//   0x0000000000000000000000000000000000000000
//   0x0000000000000000000000000000000000000000
//   0x0000000000000000000000000000000000000000

    constructor(bytes32[3] memory _data) {
        data = _data;
    }

    function unlock(bytes16 _key) public {
        require(_key == bytes16(data[2]));
        locked = false;
    }

    /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
    */
}