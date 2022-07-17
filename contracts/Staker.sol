// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";
import "./TargetContract.sol";

contract Staker {
   
     uint256 public totalStaked;
     uint256 public threshold;
     uint256 public time;
     uint256 public deadline  = block.timestamp + time;
     bool public openForWithdraw = false;
     mapping(address => uint) public balances;

     TargetContract public targetContract;
     event Stake(address staker, uint256 amount );
     event StakingStarted(uint time, uint threshold );

    constructor(address payable targetContractAddress) {
       targetContract = TargetContract(targetContractAddress);
    }
    
    //set funding target and duration
    function setGoal( uint _fundingTarget, uint _time) public {
        time = _time;
        threshold = _fundingTarget;
        emit StakingStarted(time, threshold);
    }
    
    function stake() public payable{
          require( deadline >= block.timestamp && threshold > address(this).balance, "Gotta be quick next time lol");

          balances[msg.sender]  = msg.value; 
          totalStaked += msg.value;
         emit Stake( msg.sender, msg.value);
    }

    function withdraw() public payable{
         require(openForWithdraw);

         if(balances[msg.sender]> 0) {
             
             (bool sent, ) = (msg.sender).call{value: msg.value}("");
             require(sent, "Failed to send Ether"); 
             delete balances[msg.sender];
         } 
         
    }
    
    //call to execute the final outcome of the staking
    function execute() public {
           require(deadline < block.timestamp || threshold == address(this).balance, "Dude just calm down and wait");

           if(threshold > address(this).balance){
             openForWithdraw = true;
           } else {
           targetContract.complete{value: address(this).balance}();
           }
    }
    
    //check the time left for staking
    function timeLeft() public view returns(uint256){

        return deadline >= block.timestamp ? (deadline - block.timestamp): 0 seconds;
    }
    
    //check the total balance
    function amountStaked() public view returns(uint256){
        return totalStaked;
    }

    receive()external payable{
       
        stake();
    } 

    fallback() external  payable{}

    
}
