const hre = require("hardhat");
const web3 = require("web3");

async function main() {

  const buyRate = web3.utils.toWei("17.23");
  const sellRate = web3.utils.toWei("17.454");

  const reportContract = await hre.ethers.deployContract("TicketMaster", ["0x43B341FBAE05D3Bfa351362d11783347E184050d", buyRate, sellRate]);
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