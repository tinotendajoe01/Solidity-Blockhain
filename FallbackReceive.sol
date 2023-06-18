// SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;


contract FallbackExample{
    uint256 public result;
     receive() external payable{
        result =1
     }
     fallback() external payable{
        result=2
     }
}