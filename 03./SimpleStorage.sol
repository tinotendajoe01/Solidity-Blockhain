//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19; //stating our version

contract  SimpleStorage {
 
    uint256 public  favoriteNumber;//defaulted to 0 i.e uint256 favoriteNumber =0

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
  }
  //view ,pure
   function retrieve( ) public view returns(uint256){
       return favoriteNumber;
   }
}