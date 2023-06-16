//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19; //stating our version

contract  SimpleStorage {
 
    uint256  myFavoriteNumber;//defaulted to 0 i.e uint256 favoriteNumber =0
//uint256[] listofFavoriteNumbers;//[8,6,4,3]
 struct Person {
     uint256 favoriteNumber;
     string name;
 }
// Person public myFriend = Person(7, 'James');
Person[] public listofPeople; //dynamic array
mapping (string => uint256) public nameToFavoriteNumber;
    function store(uint256 _favoriteNumber) public {
        myFavoriteNumber = _favoriteNumber;
  }
  //view ,pure
   function retrieve( ) public view returns(uint256){
       return myFavoriteNumber;
   }

   //calldata, memory, storage
   function addPerson(string memory _name, uint256 _favoriteNumber) public{
       
       
       listofPeople.push(Person(_favoriteNumber ,_name));
       nameToFavoriteNumber[_name]= _favoriteNumber;
   }
}