// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

//ERC20: https://eips.ethereum.org/EIPS/eip-20
// copy code : https://wizard.openzeppelin.com/ https://github.com/transmissions11/solmate

contract ManualToken {
    error ManualToken__NotSufficientBalance();

    mapping(address => uint256) private s_accountBalances;

    /** Events **/
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    function name() public pure returns (string memory) {
        return "Manual Token";
    }

    function symbol() public pure returns (string memory) {
        return "MT";
    }

    function totalSupply() public pure returns (uint256) {
        return 100 ether;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return s_accountBalances[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        // Transfers _value amount of tokens to address _to, and MUST fire the Transfer event.
        // The function SHOULD throw if the message caller’s account balance does not have enough tokens to spend.
        // Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
        uint256 senderBalance = balanceOf(msg.sender);
        if (senderBalance < _value) {
            revert ManualToken__NotSufficientBalance();
        }
        s_accountBalances[msg.sender] -= _value;
        s_accountBalances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }
}
