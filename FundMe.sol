// We will fo here : Get funds from user, withdraw funds and set a minimun funding value in USD

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


library PriceConverter{

    function getprice() internal view returns (uint256){
        //Address - ETH/USD - 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //ABI  

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        (,int256 price,,,) = priceFeed.latestRoundData();
        //price of ETH in the terms of USD
        return uint256(price * 1e10);
    }

    function getConversionRate (uint256 ethAmount) internal view returns(uint256){
        
        uint256 ethPrice = getprice();
        //(2000_000000000000000000 * 1000000000000000000) / 1e18
        //$2000 = 1ETH
        uint256 ethAmountinUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountinUsd;
    }

    function getVersion() internal view returns (uint256){
        return AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF).version();
    }    

}

contract FundMe{
    using PriceConverter for uint256; // so uint256 get access to all the functions are in the PriceConverter

    uint256 public constant minUsd=50 * 1e18;
    address[] public funders ;

    mapping(address funders => uint256 amountFunded) public addressToAmountFunded;
    
    address public immutable owner; 
    constructor() {  //we use constructor for safety for withdraw function, is should only be execute by owner only
        owner = msg.sender;
    }

    function fund() public payable {

        // msg.value.getConversionRate();
        require(msg.value.getConversionRate() >= minUsd, "Didnt send enough Ethers"); //1e18 = 1ETH = 10^18 WEI
        
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender]  +=  msg.value;
    }

    function Withdraw() public onlyOwner {
        // we use here for loop
        //for(starting index, ending index, step amount)
        for(uint256 funderIndex=0; funderIndex<funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;

        }
        // reset the funders array
        funders= new address[](0);
        //actually withdraw the funds
        
        // transfer -> send -> call

        //Transfer
        // msg.sender = address
        //payable(msg.sender = payable address
        payable(msg.sender).transfer(address(this).balance);

        //Send
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess,"Payment Failed"); //if tranx failed, this mssg will showup

        //Call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess,"Call Failed");
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"Must be owner!!"); //it using the contructor 
        _;     // this means 'you can add anything in function after this'
    }

    receive() external payable{
        fund();
    }
    
    fallback() external payable{
        fund();
    }


}