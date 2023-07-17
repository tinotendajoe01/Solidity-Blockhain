// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;
// This is considered an Exogenous, Decentralized, Anchored (pegged), Crypto Collateralized low volitility coin

import { ERC20Burnable, ERC20 } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title DecentralizedStableCoin
 * @notice This contract represents a crypto collateralized low volatility coin which is pegged to USD.
 * @author Tinotenda Joe
 * This contract can be minted and burned by the DSCEngine smart contract.
 */

contract DecentralizedStableCoin is ERC20Burnable, Ownable {
	error DecentralizedStableCoin__AmountMustBeMoreThanZero();
	error DecentralizedStableCoin__BurnAmountExceedsBalance();
	error DecentralizedStableCoin__NotZeroAddress();

	/**
     * @notice Constructor for the DecentralizedStableCoin contract.
     * @dev In future versions of OpenZeppelin contracts package, Ownable must be declared with an address 
     * of the contract owner as a parameter.
	 * For example:
           constructor() ERC20("DecentralizedStableCoin", "DSC") Ownable(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) {}
            Related code changes can be viewed in this commit:
             https://github.com/OpenZeppelin/openzeppelin-contracts/commit/13d5e0466a9855e9305119ed383e54fc913fdc60
 */
	constructor() ERC20("DecentralizedStableCoin", "DSC") {}

	/**
	 * @notice Allows the contract owner to burn a specified amount of DSC.
	 * @dev Only the owner can burn the tokens. Also, the amount to burn should be less or equal than the balance
	 * and greater than zero.
	 * @param _amount The amount of DSC to be burned
	 */

	function burn(uint256 _amount) public override onlyOwner {
		uint256 balance = balanceOf(msg.sender);
		if (_amount <= 0) {
			revert DecentralizedStableCoin__AmountMustBeMoreThanZero();
		}
		if (balance < _amount) {
			revert DecentralizedStableCoin__BurnAmountExceedsBalance();
		}
		super.burn(_amount);
	}

	/**
	 * @notice Mints a specified amount of DSC to a specified account.
	 * @dev This function can only be executed by the contract owner and the `_to` address should not be
	 * a zero address. Also the `_amount` should be greater than zero.
	 * @param _to The destination address to mint to.
	 * @param _amount The amount of DSC to be minted.
	 * @return Returns true if the function executes successfully.
	 */
	function mint(
		address _to,
		uint256 _amount
	) external onlyOwner returns (bool) {
		if (_to == address(0)) {
			revert DecentralizedStableCoin__NotZeroAddress();
		}
		if (_amount <= 0) {
			revert DecentralizedStableCoin__AmountMustBeMoreThanZero();
		}
		_mint(_to, _amount);
		return true;
	}
}
