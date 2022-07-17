
const hre = require("hardhat");
require("dotenv").config({ path: ".env" });
require("@nomiclabs/hardhat-etherscan");

async function main() {
  
  //deploy the target contract
  const target = await hre.ethers.getContractFactory("TargetContract");
  const deployedTarget = await target.deploy();

  await deployedTarget.deployed();

  /*console.log("Verifying Contract...")

  await pending(60000);
   
  await hre.run("verify:verify", {
    address:deployedTarget.address,
    constructorArguments: [],
  });*/

  console.log("Target contract depolyed to", deployedTarget.address);
  
  //deploy the staking contract
  const staker = await hre.ethers.getContractFactory("Staker");
  const deployedStaker = await staker.deploy(deployedTarget.address);

  await deployedStaker.deployed();
  
  
  /*console.log("Verifying Contract...")
  
  await pending(60000);
   
  await hre.run("verify:verify", {
    address:deployedStaker.address,
    constructorArguments: [deployedTarget.address],
  });*/

  console.log("staker contract depolyed to", deployedStaker.address);
}


function pending(ms){
  return new Promise(resolve => setTimeout(resolve, ms)) ;
}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
