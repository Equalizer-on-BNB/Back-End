require('dotenv').config();

const Web3 = require("web3");
const HDWalletProvider = require('@truffle/hdwallet-provider');
const contract = require("truffle-contract");
const equalizerProtocolArtifact = require("./build/contracts/EqualizerProtocol.json"); // Adjust the path to your contract's JSON artifact

const mnemonic = process.env["MNEMONIC"].toString().trim();
const infuraApiKey = process.env["INFURA_API_KEY"]; // Replace with your Infura API key

async function deploy() {
  const provider = new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/${infuraApiKey}`); // Adjust the network and URL as needed
  const web3 = new Web3(provider);

  const EqualizerProtocol = contract(equalizerProtocolArtifact);
  EqualizerProtocol.setProvider(web3.currentProvider);

  try {
    const accounts = await web3.eth.getAccounts();
    const deployer = accounts[0];

    console.log(`Deploying contract using account: ${deployer}`);

    const deployedInstance = await EqualizerProtocol.new({ from: deployer });

    console.log(`Contract deployed at address: ${deployedInstance.address}`);
  } catch (error) {
    console.error("Error deploying contract:", error);
  }

  provider.engine.stop();
}

deploy();
