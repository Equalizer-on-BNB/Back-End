const HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config();

const mnemonic = process.env["MNEMONIC"].toString().trim();

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
    },
    opBNBTestnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://opbnb-testnet-rpc.bnbchain.org`),
      network_id: 5611,
      confirmations: 3,
      timeoutBlocks: 200,
      skipDryRun: true,
    },
  },

  mocha: {
    // timeout: 100000
  },

  compilers: {
    solc: {
      version: "^0.8.0",
    },
  },
};
