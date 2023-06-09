const { ethers } = require("hardhat");

const localChainId = "31337";

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  const diceGame = await ethers.getContract("DiceGame", deployer);


  await deploy("RiggedRoll", {
    from: deployer,
    args: [diceGame.address],
    log: true,
  });


  const riggedRoll = await ethers.getContract("RiggedRoll", deployer);

  const ownershipTransaction = await riggedRoll.transferOwnership("0x1c0AcCc24e1549125b5b3c14D999D3a496Afbdb1");

  const [owner] = await ethers.getSigners();

  const transactionHash = await owner.sendTransaction({
    to: riggedRoll,
    value: ethers.utils.parseEther("0.002"),
  });


};

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

module.exports.tags = ["RiggedRoll"];
