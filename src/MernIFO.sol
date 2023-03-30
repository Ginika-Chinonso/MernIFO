// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract MernIFO {

    //@dev contract Admin
    address public Admin;

    //@dev errors
    error NotAdmin();
    
    //@dev IFO details
    struct IFO {
        uint starttime;
        uint endtime;
        uint duration;
        address proposer;
        // bool hasStarted;
        address tokenforsale;
        uint amtofTokenforSale;
        uint amountRaised;
        mapping(address => uint) amountContrib;
    }

    //@dev Total number of IFOs
    uint totalIFOs;

    //@dev mapping of IFO id to IFO details
    mapping(uint => IFO) public IFODetail;

    constructor () {
        Admin = msg.sender;
    }

    //@dev create IFO
    function createIFO(address _tokenforsale, uint _amtofTokenforSale, uint _duration) public returns (uint IFOId) {
        totalIFOs++;
        IFOId = totalIFOs;
        IFO storage _ifo = IFODetail[IFOId];
        _ifo.tokenforsale = _tokenforsale;
        _ifo.amtofTokenforSale = _amtofTokenforSale;
        _ifo.duration = _duration;
        _ifo.proposer = msg.sender;
    }

    
    //@dev ALlows Admin to start an IFO
    function startIFO(uint _id) public {
        require(msg.sender == Admin, "Only Admin can start an IFO");
        IFO storage _ifo = IFODetail[_id];
        _ifo.starttime = block.timestamp;
        _ifo.endtime = _ifo.starttime + _ifo.duration;
    }


    //@dev contribute to an IFO
    //@params _id is the id of the IFO to contribute to
    function contribute(uint _id) public payable {
        IFO storage _ifo = IFODetail[_id];

        //@dev initial checks
        require(msg.value != 0, "Cant contribute zero ETH");
        require(block.timestamp > _ifo.starttime || block.timestamp < _ifo.endtime, "IFO is not currently ongoing");

        _ifo.amountContrib[msg.sender] += msg.value;
        _ifo.amountRaised += msg.value;

        (bool success, ) = payable(address(this)).call{value: msg.value}("");
        require(success, "Transfer failed");
    }


    //@dev withdraw token gotten from contribution
    function recieveToken(uint _id) public {
        IFO storage _ifo = IFODetail[_id];

        //@dev initial checks
        require(block.timestamp > _ifo.endtime, "IFO still ongoing");

        uint amountContrib = _ifo.amountContrib[msg.sender];
        uint totalAmtRaised = _ifo.amountRaised;
        uint percentContrib = (amountContrib / totalAmtRaised ) * 100;

        uint amttoRecieve = percentContrib * _ifo.amtofTokenforSale;
        address tokenAddr = _ifo.tokenforsale;
        IERC20(tokenAddr).transfer(msg.sender, amttoRecieve);
    }


    //@dev enables admin to withdraw eth to prevent stuck funds.
    function withdrawETH() public {
        require(msg.sender == Admin, "Only Admin can call this function");
        (bool success,) = payable(address(Admin)).call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }

    fallback() external payable {}

    receive() external payable {}
}
