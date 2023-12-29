require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      // url: process.env.RPC_URL,
      accounts: ["23e6e8d63726b6628670497f8f995933ae61c473ca94bbafced957d0843edfcc"]
      // accounts: [process.env.PRIVATE_KEY]
    },
  },
  etherscan: {
    // apiKey: process.env.API_KEY,
    apiKey: "PSR2AW4RMINCJ5Y3TMG75FDSRWVWVC1X5D",
  },
};
