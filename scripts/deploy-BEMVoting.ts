import { ethers } from "hardhat";
import { PemilihanBEM } from "../typechain-types";

async function main() {

  // Get deployer account
  const [deployer] = await ethers.getSigners();

  // Check balance
  const balance = await ethers.provider.getBalance(deployer.address);
  console.log("├── Deployer balance:", ethers.formatEther(balance), "MON");

  if (balance < ethers.parseEther("0.01")) {
    console.log("⚠️  Warning: Low balance. Make sure you have enough MON for deployment.");
  }

  // Get network info
  const network = await ethers.provider.getNetwork();

  // Deploy TaskManager
  const BEMVoting = await ethers.getContractFactory("PemilihanBEM");

  // Estimate gas
  const deployTx = await BEMVoting.getDeployTransaction(1749566586, 1750430586); //constructor
  const estimatedGas = await ethers.provider.estimateGas(deployTx);
  console.log("├── Estimated gas:", estimatedGas.toString());

  // Deploy with manual gas limit (adding 20% buffer)
  const gasLimit = (estimatedGas * BigInt(120)) / BigInt(100);
  const taskManager: PemilihanBEM = await BEMVoting.deploy(1749566586, 1750430586);//constructor

  // Wait for deployment
  await taskManager.waitForDeployment();
  const contractAddress = await taskManager.getAddress();

  console.log("✅ TaskManager deployed successfully!");
  console.log("├── Contract address:", contractAddress);
  console.log("├── Block explorer:", `https://testnet.monadexplorer.com/address/${contractAddress}`);

  // Verify initial state
  console.log("\n🔍 Verifying initial contract state...");
  try {
    // const owner = await taskManager.owner();
    // const taskCount = await taskManager.taskCount();
    // const userTaskCount = await taskManager.userTaskCount(deployer.address);


    // Test calculateFee function
    // const fee = await taskManager.calculateFee(100);
    // console.log("└── Fee calculation (100 -> 2%):", fee.toString());

  } catch (error) {
    console.log("❌ Error verifying contract state:", error);
  }

  // Get deployment cost
  const deploymentTx = taskManager.deploymentTransaction();
  if (deploymentTx) {
    const receipt = await deploymentTx.wait();
    if (receipt) {
      const cost = receipt.gasUsed * receipt.gasPrice;
    }
  }


  // Save deployment info to file
  const deploymentInfo = {
    contractAddress: contractAddress,
    deployerAddress: deployer.address,
    network: network.name,
    chainId: network.chainId.toString(),
    blockExplorer: `https://testnet.monadexplorer.com/address/${contractAddress}`,
    timestamp: new Date().toISOString(),
    txHash: deploymentTx?.hash
  };

  // Write to file (optional)
  const fs = require('fs');
  const path = require('path');
  const deploymentsDir = path.join(__dirname, '..', 'deployments');

  if (!fs.existsSync(deploymentsDir)) {
    fs.mkdirSync(deploymentsDir);
  }

  fs.writeFileSync(
    path.join(deploymentsDir, 'taskmanager-monad-testnet.json'),
    JSON.stringify(deploymentInfo, null, 2)
  );


  return {
    taskManager,
    contractAddress,
    deploymentInfo
  };
}

// Handle errors
main()
  .then(() => process.exit(0))

  .catch((error) => {
    console.error("\n❌ Deployment failed:");
    console.error("teu aya saldo");
    console.error(error);
    process.exit(1);
  });