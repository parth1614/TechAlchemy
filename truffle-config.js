const Web3 = require("web3");
require('babel-register');
require('babel-polyfill');
const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');
const mnemonic = fs
  .readFileSync('.secret')
  .toString()
  .trim();
const ethKey = fs
  .readFileSync('.ethKey')
  .toString()
  .trim();

const NODE_URL = "https://speedy-nodes-nyc.moralis.io/414dc4cc304d08be29a106e4/polygon/mumbai/archive";
const provider = new Web3.providers.HttpProvider(NODE_URL);
const web3 = new Web3(provider);


module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '*', // Match any network id
    },

  },

  contracts_directory: './src/contracts/',
  contracts_build_directory: './src/abis/',
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      evmVersion: 'petersburg',
    },
  },

  //etherscan API key
  api_keys: {
    etherscan: ethKey,
  },
  // plugin for verification
  plugins: ['truffle-plugin-verify'],
};

//truffle test

// call console - truffle console
// get contract - await TestToken.deployed()

// to compile - truffle compile
// to deploy - truffle migrate --reset

