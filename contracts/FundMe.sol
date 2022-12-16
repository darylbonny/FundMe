// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.3.2 (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/FeedRegistryInterface.sol";
import "@chainlink/contracts/src/v0.8/Denominations.sol";


contract FundMe {
   
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;
   
    constructor() {
        owner = msg.sender;
       
    }
   
    function fund() public payable {
       
        uint256 minimumUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
   
    function getVersion() public view returns (uint256) {
       
        //AggregatorV3Interface priceFeed = AggregatorV3Interface("Insert WEB3 address");
        //return priceFeed.version();
    }
   
    function getPrice() public view returns (uint256) {
       
        //AggregatorV3Interface priceFeed = AggregatorV3Interface("Insert WEB3 address");
        //(,int256 answer,,,) = priceFeed.latestRoundData();
        //return uint256(answer * 10000000000);
    }
   
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
       
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }
   
    modifier onlyOwner {
       
        require(msg.sender == owner);
        _;
       
    }

    function withdraw() payable onlyOwner public {
       
        payable(msg.sender).transfer(address(this).balance);
        for (uint256 funderInder = 0; funderInder < funders.length; funderInder++) {
            address funder = funders[funderInder];
            addressToAmountFunded[funder] = 0;
        }
       
        funders = new address[] (0);
    }
}