// Here we use fallback and recieve solidity in-built functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract FallbackExample {
    uint public result;

    receive() external payable{  //if low level interaction is empty, this will deploy
        result = 10000;
    }
    fallback() external payable{ // if low level interaction is having some hexadecimal value, this will deply
        result=20000;
    }
}
