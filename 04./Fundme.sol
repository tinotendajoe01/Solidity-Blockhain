
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

//a custom error
error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
   //a mapping to keep tract of how much each funder has funded
    mapping(address => uint256) public addressToAmountFunded;
    //an array to keep track of all funders
    address[] public funders;
address payable public fundsDestination;
   // immutable contract owner
    address public i_owner; /* immutable */ 
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18; //minimu ammount that can be funded in usd
   //goal
    uint256 public maxGoal;
    uint256 public deadline;

  // an event to be emitted when new funds are donated
event NewDonation(address indexed funder, uint256 amount);
    // this constructor sets the contract owner to the deployer
    constructor() {
        i_owner = msg.sender;
    }
    // a struct to store the details of a funder
struct Funder {
    address funderAddress;
    uint256 amountFunded;
}
    function setMaxGoal(uint256 _maxGoal) onlyOwner public{
        maxGoal= _maxGoal;
    }
    function setDeadline(uint256 _deadline) public onlyOwner {
    deadline = _deadline;
}
   function fund() public payable {
    // Check that the amount of ETH being sent is at least the minimum amount in USD
    require(msg.value.getConversionRate() >= MINIMUM_USD, "You need to spend more ETH!");

    // Check that the maximum goal has not been reached yet
    if (maxGoal > 0) {
        require(address(this).balance + msg.value <= maxGoal, "Maximum goal reached!");
    }

    // Check if the deadline has passed
    if (deadline > 0) {
        require(block.timestamp <= deadline, "Deadline has passed, cannot fund!");
    }
    
    // Update the mapping with the amount funded by the sender
    addressToAmountFunded[msg.sender] += msg.value;

    // Add the sender to the list of funders
    funders.push(msg.sender);

 if (maxGoal > 0 && address(this).balance == maxGoal) {
        // Transfer the funds to the destination address
        fundsDestination.transfer(address(this).balance);
    }
    emit NewDonation(msg.sender, msg.value);
}
    //get the version of chainlink pricefeed being use--- help in geting the contract ABI
    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }
    
    // a function to check if the deadline has passed
function hasDeadlinePassed() public view returns (bool) {
    return (deadline > 0 && block.timestamp > deadline);
}
    modifier onlyOwner {
        // require(msg.sender == owner, "sender not owner");
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }
    
    function withdraw() public onlyOwner {
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);
        
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
    function setFundsDestination(address payable _fundsDestination) public onlyOwner {
    fundsDestination = _fundsDestination;
}
     function getContractBalance() public  view returns(uint256){
        return address(this).balance;
     }

function withdrawFunds() public {
    if (maxGoal>0){
        require (address(this).balance < maxGoal,"Max balance reached, cannot withdraw funds");
    }
     uint256 ammountFunded = addressToAmountFunded[msg.sender];
     require(ammountFunded>0, "Sender has not funded any amount");
     addressToAmountFunded[msg.sender]=0;
     for (uint256 funderIndex=0; funderIndex< funders.length; funderIndex++){
        if (funders[funderIndex]== msg.sender){
            funders[funderIndex]= funders[funders.length- 1];
            funders.pop();
            break;
        }
     }
     payable(msg.sender).transfer(ammountFunded);
}
function getDonations() public view returns (Funder[] memory) {
    Funder[] memory donations = new Funder[](funders.length);

    for (uint256 i=0; i < funders.length; i++) {
        address funder = funders[i];
        uint256 amount = addressToAmountFunded[funder];
        donations[i] = Funder(funder, amount);
    }

    return donations;
}

    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()

//call when the contract receive ETH without any data
    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

}






