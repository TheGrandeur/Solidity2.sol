// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract SafeMathTester{
    uint8 public finalNumber = 255;
    function Add() public {
       unchecked{ finalNumber=finalNumber+1;} //we use unchecked mark for gas efficient
    }                                         //Before using unchecked mark, this function was using infinite gas
}
