# NFT Marketplace: Decentralized Escrow E-Commerce

## 1. Project Overview
The **NFT Marketplace** is a fully decentralized, Web3-native e-commerce platform built on the Ethereum blockchain. Traditional NFT marketplaces perform immediate "atomic swaps" of digital assets for cryptocurrency, which fail when dealing with physical goods, real-world services, or delayed-delivery assets. 

This project solves the "fair exchange" problem by acting as a **trustless smart-contract escrow**. It safely holds both the seller's NFT and the buyer's funds simultaneously. Funds are only released to the seller once the buyer confirms delivery. If a dispute arises or a buyer goes unresponsive, **Chainlink Automation** handles the dispute resolution autonomously, returning assets to their rightful owners.

### Key Features
* **Dual-Escrow Mechanism:** Holds both the NFT and the ETH locked in the smart contract until conditions are met.
* **USD-Pegged Pricing:** Sellers list items in USD. The contract uses **Chainlink Price Feeds** to dynamically calculate the exact amount of ETH required at the exact moment of purchase, protecting against crypto volatility.
* **Automated Dispute Resolution:** If a buyer refuses to confirm delivery after receiving an item, **Chainlink Automation** triggers an automatic `Refund()` after a specified time period, eliminating deadlocks without needing a human moderator.
* **100% On-Chain:** Fully decentralized logic built with Solidity and tested with Foundry.

---

## 2. Technology Stack
* **Smart Contracts:** Solidity (`^0.8.18`)
* **Development Framework:** Foundry (Forge, Anvil, Cast)
* **Oracles & Automation:** Chainlink Data Feeds (ETH/USD), Chainlink Automation (Keepers)
* **Frontend:** React.js, Vite, TailwindCSS
* **Web3 Integration:** Ethers.js

---

## 3. Local Setup & Installation Guide

Follow these steps to run the complete platform (Smart Contracts + React Frontend) on your local computer.

### Prerequisites
Make sure you have the following installed on your machine:
* [Git](https://git-scm.com/)
* [Node.js](https://nodejs.org/) (v16 or higher)
* [Foundry](https://book.getfoundry.sh/getting-started/installation) (Forge, Anvil, Cast)
* MetaMask (Browser Extension)

### Step 1: Clone the Repository & Install Dependencies
First, clone the project and install the smart contract dependencies.
```bash
git clone <your-repository-url>
cd NFTX-main

# Install Foundry dependencies (OpenZeppelin, Chainlink, Forge-Std)
forge install
```

### Step 2: Start the Local Blockchain
We will use Anvil, Foundry's local Ethereum node, to run a local blockchain.
Open a **new terminal window**, navigate to the project directory, and run:
```bash
anvil
```
*Leave this terminal running.* Anvil will provide you with a list of 10 test accounts and their private keys. Each account comes pre-loaded with 10,000 fake ETH.

### Step 3: Deploy Contracts to Localhost
Open a **new terminal window** in the project directory. We will deploy the contracts to the local Anvil node using the first private key provided by Anvil.

```bash
# Replace <ANVIL_PRIVATE_KEY> with the very first private key printed in the Anvil terminal (starts with 0x)
forge script script/NFTXScript.s.sol:NFTXScript --rpc-url http://127.0.0.1:8545 --broadcast --private-key <ANVIL_PRIVATE_KEY>
```
Once deployed, the terminal will output the **Contract Address** (e.g., `0x5FbDB2315678afecb367f032d93F642f64180aa3`). **Copy this address.**

### Step 4: Configure the Frontend
You must tell the React frontend where your newly deployed contract lives.
1. Open the project in your code editor.
2. Navigate to the following files in `NFTX/src/components/`:
   * `BuyItem/BuyItem.jsx`
   * `SellItem/SellItem.jsx`
   * `Confirm/Confirm.jsx`
3. Find the line that looks like this (usually near line 8):
   ```javascript
   const WalletAddress = "0x1165fDE0D4e9c0830A15B395dD753e1F6748bE56"; // (Old Address)
   ```
4. Replace the old address with the **new Contract Address** you copied in Step 3. Save all files.

### Step 5: Start the React Frontend
Now, boot up the Vite development server for the UI.
```bash
# Navigate into the frontend folder
cd NFTX

# Install Node dependencies
npm install

# Start the server
npm run dev
```
The application will now be running at `http://localhost:5173/`.

### Step 6: Connect Your Wallet & Test
1. Open your browser and go to `http://localhost:5173/`.
2. Open the MetaMask extension. 
3. Go to network settings and add/switch to **Localhost 8545** (RPC URL: `http://127.0.0.1:8545`, Chain ID: `31337`).
4. Import an account into MetaMask using one of the private keys provided by your Anvil terminal.
5. Click **Connect Wallet** on the website and start testing the platform!

---

## 4. Deployed Contracts (Sepolia Testnet)
The smart contracts have been successfully deployed and verified on the Sepolia testnet at the following addresses:
* **NFTX:** `0x743cddb3dbaa33ce8ef6bd471ee3e0a7be220028`
* **NFTXNFT:** `0xC944E7648F1c90e39Ed6f3125315835ca8aB8611`

