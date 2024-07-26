// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract OurToken is ERC20, ERC20Permit {
    constructor(
        uint256 initialSupply
    ) ERC20("OutToken", "OT") ERC20Permit("OutToken") {
        _mint(msg.sender, initialSupply);
    }
}
