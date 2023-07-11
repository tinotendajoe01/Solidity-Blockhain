// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;
import { Script } from "forge-std/Script.sol";
import { FundProject } from "../src/FundProject.sol";
import { HelperConfig } from "./HelperConfig.s.sol";
import { FundRaffleMoodNft } from "../src/FundRaffleNft.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployFundProject is Script {
	function svgToImageURI(
		string memory svg
	) public pure returns (string memory) {
		// example:
		// '<svg width="500" height="500" viewBox="0 0 285 350" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill="black" d="M150,0,L75,200,L225,200,Z"></path></svg>'
		// would return ""
		string memory baseURL = "data:image/svg+xml;base64,";
		string memory svgBase64Encoded = Base64.encode(
			bytes(string(abi.encodePacked(svg)))
		);
		return string(abi.encodePacked(baseURL, svgBase64Encoded));
	}

	function run()
		external
		returns (FundProject, HelperConfig, FundRaffleMoodNft)
	{
		string memory sadSvg = vm.readFile("./images/dynamicNft/sad.svg");
		string memory happySvg = vm.readFile("./images/dynamicNft/happy.svg");

		HelperConfig helperConfig = new HelperConfig();
		address priceFeed = helperConfig.activeNetworkConfig();
		vm.startBroadcast();
		FundRaffleMoodNft fundRaffleMoodNft = new FundRaffleMoodNft(
			svgToImageURI(sadSvg),
			svgToImageURI(happySvg)
		);
		FundProject fundProject = new FundProject(
			priceFeed,
			address(fundRaffleMoodNft)
		);
		vm.stopBroadcast();
		return (fundProject, helperConfig, fundRaffleMoodNft);
	}
}
