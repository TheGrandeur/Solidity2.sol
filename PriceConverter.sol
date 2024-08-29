// In this we are going to learn about the libraries and how to use libraries

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
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }    

}
