const hre = require("hardhat");

async function main() {

  const reportContract = await hre.ethers.deployContract("TicketMaster");

  await reportContract.waitForDeployment();

  console.log(
    `success! contract deployed to ${reportContract.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});