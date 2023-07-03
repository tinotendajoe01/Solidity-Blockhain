// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConvertor {
	function getPrice(
		AggregatorV3Interface priceFeed
	) internal view returns (uint256) {
		(, int256 answer, , , ) = priceFeed.latestRoundData();
		return uint256(answer * 10000000000);
	}

	function getConversionRate(
		uint256 ethAmount,
		AggregatorV3Interface priceFeed
	) internal view returns (uint256) {
		uint256 ethPrice = getPrice(priceFeed);
		uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
		return ethAmountInUsd;
	}
}
