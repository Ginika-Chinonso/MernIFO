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
        merntoken.transfer(address(ifo), 1000 ether);
    }

    function testCreateIFO() public {
        uint _amt = 1000 ether;
        merntoken.approve(address(ifo), _amt);
        console.log(merntoken.balanceOf(address(this)));
        ifo.createIFO(address(merntoken), _amt, 5 minutes);

    }

    function testStartIFO() public {
        testCreateIFO();
        ifo.startIFO(1);
    }

    function testContribute() public {
        testStartIFO();
        console.log(address(this).balance);
        vm.deal(address(0x01), 20 ether);
        vm.deal(address(0x02), 20 ether);
        vm.deal(address(0x03), 20 ether);
        vm.prank(address(0x01));
        ifo.contribute{value: 2 ether}(1);
        vm.prank(address(0x02));
        ifo.contribute{value: 1 ether}(1);
        vm.prank(address(0x03));
        ifo.contribute{value: 3 ether}(1);
        ifo.contribute{value: 5 ether}(1);
        console.log(address(this).balance);
        console.log(address(ifo).balance);
    }

    //272 727 272 727 272 727 272 // addr3//3E
    //454 545 454 545 454 545 454 // addr//5E
    //181 818 181 818 181 818 181//addr1//2E
    //90 909 090 909 090 909 090 //addr2//1E
    

    function testRecieveToken() public {
        testContribute();
        vm.warp(block.timestamp + 5 days);
        console.log(merntoken.balanceOf(address(this)));
        ifo.recieveToken(1);
        console.log(merntoken.balanceOf(address(this)));
    }

    function testGetContributorInfo() public {
        testContribute();
        ifo.getContributorInfo(1, address(this));
        ifo.getContributorInfo(1, address(0x01));
        ifo.getContributorInfo(1, address(0x02));
        ifo.getContributorInfo(1, address(0x03));
    }

    function testWithdrawETH() public {
        testContribute();
        ifo.withdrawETH();
    }

    function testCalculateTokenAllocation() public {
        testContribute();
        ifo.calculateTokenAllocation(1, address(this));
        ifo.calculateTokenAllocation(1, address(0x01));
        ifo.calculateTokenAllocation(1, address(0x02));
        ifo.calculateTokenAllocation(1, address(0x03));
    }

    fallback() external payable {}

    receive() external payable {}
}
