const NFTContract = artifacts.require("NFTContract");
const Marketplace = artifacts.require("Marketplace");

module.exports = async (deployer) => {
  await deployer.deploy(Marketplace);

  const marketplace = await Marketplace.deployed();
  
  await deployer.deploy(NFTContract,"ContractNFT", "NFT", marketplace.address);
};
