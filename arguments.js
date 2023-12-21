// hardhat arguments.js here
const web3 = require("web3");
const buyRate = web3.utils.toWei("17.23");
const sellRate = web3.utils.toWei("17.454");

module.exports = [   
     "0x43B341FBAE05D3Bfa351362d11783347E184050d",
    buyRate,
    sellRate
]