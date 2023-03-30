// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Mern is ERC20 {

    constructor (string memory _name, string memory _symbol) ERC20(_name, _symbol) {}

    function mint(uint _amount) public {
        _mint(msg.sender, _amount);
    }
}
