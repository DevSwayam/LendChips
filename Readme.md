
# Cross-Chain Lending and Borrowing DApp

### This project is a submission to Chainlink Constelation hackathon.

![Project Logo](https://github.com/TechieeGeeeks/HyperHack/assets/99035115/c92a05b9-0262-4b67-b3fa-684710c76585)

## Table of Contents

- [Introduction](#introduction)
- [Demo](#demo)
- [Usage](#usage)
- [Features](#features)
- [Detailed Explanation](#detailed-explanation)

## Introduction

Welcome to the Cross-Chain Lending and Borrowing DApp, a revolutionary decentralized application that simplifies lending and borrowing for NFTs across various blockchain networks. This DApp addresses common challenges faced by NFT owners seeking loans on multiple chains.

## Demo

For a detailed explanation of how this DApp works, please refer to the following demo videos:

- [Project Explanation](https://drive.google.com/file/d/1EzMPTAwo9_JVxzh8l3koMYeXHM3NawLT/view?usp=drive_link)
- [Cross-Chain Lending and Borrowing Demo](https://drive.google.com/file/d/1no3zu4GqmTOPO7R6E-Tu38X8ROKYKJZE/view?usp=drive_link)

These videos provide an in-depth understanding of the project, including setup instructions and an overview of its features.

## Usage

Our DApp simplifies the process of lending and borrowing NFTs across various blockchain networks. You can deposit NFTs on any chain, accumulate borrowing power, and withdraw tokens from any available chain. Loan repayment can also be done on any chain.

## Detailed Explanation

**Project Explanation**

The Cross-Chain Lending and Borrowing DApp is a remarkable submission to the Chainlink Constelation hackathon. This innovative decentralized application, developed to simplify the lending and borrowing of NFTs across different blockchain networks, addresses the common challenges faced by NFT owners when they seek loans across multiple chains.

Suppose you own NFTs on various blockchain networks and you require a loan. This DApp provides a comprehensive solution by enabling cross-chain lending and borrowing for NFTs. This project can be understood as the culmination of a series of solutions significant problems.

1. **Multiple Chain NFTs and Loans**: Imagine you have NFTs with a total value of $1200, with $500 worth of NFTs on Ethereum and $700 worth of NFTs on Polygon. In the traditional lending and borrowing space, you would need to lend your NFTs on separate protocols, such as Bentdao for Ethereum and a similar protocol for Polygon. This complicates the lending process, and there's a catch with platforms like Polygon. In Polygon's NFT lending and borrowing space, you must consider the health factor of your NFTs. If the health factor falls below a specific threshold, your valuable NFTs might get liquidated. Consequently, you must continuously monitor your NFTs across various all protocols all chains and ensure their floor price remains higher than the loan amount. This poses a considerable challenge to NFT owners.

2. **Repaying Loans Across Multiple Protocols**: Even if you successfully lend your NFTs on multiple protocols, you will face the daunting task of repaying loans across those different platforms. For instance, if you've lent an NFT on bentDao on Ethereum chain, you will have to repay the loan on Ethereum. Similarly, you'll have to do the same for any other blockchain on which you've engaged in lending. This cumbersome process requires constant communication with multiple protocols, making it complex and time-consuming.

Recognizing these problems, the project presents a holistic solution: a Cross-Chain Lending and Borrowing platform built on Chainlink CCIP . It offers a streamlined approach to lending, borrowing, and managing NFTs. The central idea is to allow users to deposit an NFT on any chain, thereby accumulating a borrowing power in the form of USD tokens. This borrowing power can be flexibly utilized for borrowing tokens across multiple chains.

Consider a scenario where you've lent NFTs on three different chains: $100 worth on Ethereum, $100 on Polygon Mumbai, and $100 on Avalanche Fuji. The DApp ensures that all three chains are synchronized. It will inform all three chains that a specific wallet address has $300 worth of borrowing power. As a result, you can easily borrow $300 worth of USD tokens from any chain. When it's time to repay the loan, the DApp ensures that all chains are aware of your outstanding loan amount, which, in this case, is $300. You can then repay the loan on any of the supported chains. If the conditions are met, all chains will release ownership of your NFTs back to you.

In summary, the Cross-Chain Lending and Borrowing DApp introduces a game-changing approach to the lending and borrowing of NFTs. By enabling cross-chain NFT deposits, accumulating borrowing power, withdrawing tokens from various chains, and repaying loans with unmatched flexibility, it opens up a world of possibilities for NFT owners and borrowers. This project promises to simplify and enhance the NFT lending and borrowing experience across the blockchain landscape.

## Features

- **Multi-Chain NFT Deposit:** Deposit NFTs on multiple chains.
- **Multi-Chain Borrowing Power:** Accumulate borrowing power across chains.
- **Multi-Chain Token Withdrawal:** Withdraw tokens from any available chain.
- **Multi-Chain Loan Repayment:** Repay loans on any chain.

## Core Features Using HyperLane Messaging

### 1. Deposit NFT

The `depositNFT` function allows users to deposit NFTs on multiple chains available on HyperLane. When a user deposits an NFT, the smart contract calculates its worth and adds it to their borrowing power, which can be used to borrow tokens on any chain. Suppose a user deposits NFTs on multiple chains to take a massive loan, then their borrowing power is incremented.

```solidity
// Solidity code for depositNFT function
function depositNFT(address tokenContractAddress, uint256 tokenID) external ownerOnly {
   
    // After satisfying all conditions

    // Giving borrowing power on all chain
        for (uint64 i = 0; i < chainIds.length; i++) {
            // Except this chain execute call for all two remaining chains
            if (thisChainId != chainIds[i]) {
                uint64 chainId = chainIds[i];
                IBridge(bridge).AddBorrowingPowerSend(
                    chainId,
                    DUSD_LOAN_AMOUNT, // msg.sender can get this much DUSD
                    msg.sender, // Who will get this DUSD
                    chainAddress[i]
                );
            }
        }
}
```

### 2. Withdraw Tokens

The `withdrawTokens` function allows users to withdraw tokens using their borrowing power. When tokens are withdrawn, the user's borrowing power is reduced. Tokens can be withdrawn from any chain, and when tokens are withdrawn, all chains will get notified, and the user's borrowing power will be reduced on all chains.

```solidity

function withDrawTokens() external {

    // After satisfying all conditions

        // Removing borrowing power on all chain
            for (uint64 i = 0; i < chainIds.length; i++) {
                // Except this chain execute call for all two remaining chains
                if (thisChainId != chainIds[i]) {
                    uint64 chainId = chainIds[i];
                    IBridge(bridge).RemoveBorrowingPowerSend(
                        chainId,
                        loanDUSD,
                        msg.sender,
                        chainAddress[i]
                    );
                }
            }
}
```

### 3. Repay Loan

The `repayLoan` function allows users to repay their loans and regain ownership of their NFTs. To repay a loan, the user must specify the borrower's address. The loan can be repaid on any chain; there are no conditions for it. When the loan is paid, the user will get ownership of all NFTs back.

```solidity

function repayLoan(address _borrower) external {

    // After satisfying all conditions

   // Now tell all chains to give back NFT ownerships
        for (uint64 i = 0; i < chainIds.length; i++) {
            // Except this chain execute call for all two remaining chains

            if (thisChainId != chainIds[i]) {
                uint64 chainId = chainIds[i];
                IBridge(bridge).GiveBackOwnershipOfNFTOnAllChains(
                    chainId,
                    0, // Dummy Number
                    _borrower,
                    chainAddress[i]
                );
            }
        }
}
```

This DApp opens up limitless possibilities for cross-chain NFT lending and borrowing.

Copyright - [@DevSwayam](https://github.com/DevSwayam)
