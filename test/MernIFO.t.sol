// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/forge-std/src/Test.sol";
import "../src/MernIFO.sol";
import "../src/Mern.sol";


contract MernIFOTest is Test {
    MernIFO public ifo;
    Mern public merntoken;


    function setUp() public {
        ifo = new MernIFO();
        merntoken = new Mern("Mern", "MRN");
        merntoken.mint(10000 ether);
    }

    function testCreateIFO() public {
        ifo.createIFO(address(merntoken), 1000 ether, 5 minutes);

    }

    function testStartIFO() public {
        testCreateIFO();
        ifo.startIFO(1);
    }

    function testContribute() public {
        testStartIFO();
        console.log(address(this).balance);
        ifo.contribute{value: 5 ether}(1);
        console.log(address(this).balance);
    }

    function testRecieveToken() public {
        testContribute();
        vm.warp(block.timestamp + 5 days);
        ifo.recieveToken(1);
    }

    function testWithdrawETH() public {
        testContribute();
        ifo.withdrawETH();
    }

    fallback() external payable {}

    receive() external payable {}
}
