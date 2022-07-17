// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";


contract TargetContract{

    bool isCompleted = false;
   
    function complete() public payable {
        require(!isCompleted);
        isCompleted  = true;
    } 

    function balance() public view returns(uint){
        return address(this).balance ;
        
   }

    receive()external payable{} 
    fallback() external payable{}

}