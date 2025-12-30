const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();

    const duration = 60 * 60;

    const seller = "0xCEA09f1DCA24ba4bC916aa4bab5E12Dfa2950188";

    const Escrow = await hre.ethers.getContractFactory("ESCROW");
    const escrow = await Escrow.deploy(seller, duration);

    await escrow.waitForDeployment();

    console.log("Escrow deployed to:", await escrow.getAddress());
    console.log("Buyer:", deployer.address);
    console.log("Seller:", seller);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
