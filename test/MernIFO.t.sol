// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/forge-std/src/Test.sol";
import "../src/MernIFO.sol";

contract MernIFOTest is Test {
    MernIFO public ifo;

    function setUp() public {
        ifo = new MernIFO();
    }

    function testCreateIFO() public {
        ifo.createIFO();

    }

    function testStartIFO(uint256 x) public {
        ifo.startIFO();
    }

    function testContribute(uint256 x) public {
        ifo.contribute(_id);
    }

    function testRecieveToken(uint256 x) public {
        ifo.recieveToken(_id);
    }

    function testWithdrawETH(uint256 x) public {
        ifo.withdrawETH(_id);
    }
}
