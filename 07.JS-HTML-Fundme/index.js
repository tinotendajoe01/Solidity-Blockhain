import { ethers } from "./ethers-5.6.esm.min.js";
import { abi, contractAddress } from "./constants.js";

const connectButton = document.getElementById("connectButton");
const withdrawButton = document.getElementById("withdrawButton");
const fundButton = document.getElementById("fundButton");
const balanceButton = document.getElementById("balanceButton");
const refundButton = document.getElementById("refundButton");
const displayFundersBtn = document.getElementById("displayFunderz");
const progressBar = document.getElementById("progress-bar");
const totalFunds = 50; // Replace with the actual total funds value
const goal = 100; // Replace with the actual goal value
window.onload = function () {
  getBalance();
  getOwner();

  displayFunders();
};

const progressPercentage = (totalFunds / goal) * 100;
progressBar.style.width = `${progressPercentage}%`;

connectButton.onclick = connect;
withdrawButton.onclick = withdraw;
fundButton.onclick = fund;
balanceButton.onclick = getBalance;
refundButton.onclick = refund;
displayFundersBtn.onclick = displayFunders;

async function connect() {
  if (typeof window.ethereum !== "undefined") {
    try {
      await ethereum.request({ method: "eth_requestAccounts" });
    } catch (error) {
      console.log(error);
    }
    connectButton.innerHTML = "Connected";
    const accounts = await ethereum.request({ method: "eth_accounts" });
    console.log(accounts);
  } else {
    connectButton.innerHTML = "Please install MetaMask";
  }
}

async function withdraw() {
  console.log(`Withdrawing...`);
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    await provider.send("eth_requestAccounts", []);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(contractAddress, abi, signer);
    try {
      const transactionResponse = await contract.withdraw();
      await listenForTransactionMine(transactionResponse, provider);
      // await transactionResponse.wait(1)
    } catch (error) {
      console.log(error);
    }
  } else {
    withdrawButton.innerHTML = "Please install MetaMask";
  }
}

async function fund() {
  const ethAmount = document.getElementById("ethAmount").value;
  console.log(`Funding with ${ethAmount}...`);
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(contractAddress, abi, signer);
    try {
      const transactionResponse = await contract.fund({
        value: ethers.utils.parseEther(ethAmount),
      });
      await listenForTransactionMine(transactionResponse, provider);
    } catch (error) {
      console.log(error);
    }
  } else {
    fundButton.innerHTML = "Please install MetaMask";
  }
}

async function getBalance() {
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    try {
      const balance = await provider.getBalance(contractAddress);
      const formattedBalance = ethers.utils.formatEther(balance);
      console.log(formattedBalance);

      // Update the balance in the HTML element
      const balanceElement = document.getElementById("balance");
      balanceElement.innerHTML = `${formattedBalance} ETH`;
    } catch (error) {
      console.log(error);
    }
  } else {
    balanceButton.innerHTML = "Please install MetaMask";
  }
}

async function getOwner() {
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const contract = new ethers.Contract(contractAddress, abi, provider);
  const ownerAddress = await contract.getOwner();
  console.log(`Contract owner: ${ownerAddress}`);
  const ownerElement = document.getElementById("owner");
  ownerElement.innerHTML = `${ownerAddress}`;
}

async function refund() {
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const signer = provider.getSigner();
  const contract = new ethers.Contract(contractAddress, abi, signer);
  const transactionResponse = await contract.refund();
  await listenForTransactionMine(transactionResponse, provider);
}
async function displayFunders() {
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const contract = new ethers.Contract(contractAddress, abi, provider);
  const funders = await contract.getFundersInfo();
  const fundersList = document.createElement("ul");

  for (const funder of funders) {
    const listItem = document.createElement("li");
    listItem.innerHTML = `${funder.funderAddress} - ${ethers.utils.formatEther(funder.fundedAmount)} ETH`;
    fundersList.appendChild(listItem);
  }

  document.getElementById("funders").appendChild(fundersList);
}

async function distributeFunds(distributionPercentage) {
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const signer = provider.getSigner();
  const contract = new ethers.Contract(contractAddress, abi, signer);
  const transactionResponse = await contract.distributeFunds(distributionPercentage);
  await listenForTransactionMine(transactionResponse, provider);
}

function listenForTransactionMine(transactionResponse, provider) {
  console.log(`Mining ${transactionResponse.hash}`);
  return new Promise((resolve, reject) => {
    provider.once(transactionResponse.hash, transactionReceipt => {
      console.log(`Completed with ${transactionReceipt.confirmations} confirmations. `);
      resolve();
    });
  });
}

function updateProgressBar(totalFunds, goal) {
  const progressPercentage = (totalFunds / goal) * 100;
  progressBar.style.width = `${progressPercentage}%`;
}
