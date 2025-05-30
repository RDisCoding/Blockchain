# FundMe - Decentralized Crowdfunding Smart Contract

A decentralized crowdfunding platform built on Ethereum that allows users to fund projects with ETH and ensures only the contract owner can withdraw funds. The contract uses Chainlink price feeds to enforce a minimum funding amount in USD equivalent.

## 🌟 Features

- **Minimum Funding Threshold**: Enforces a minimum $5 USD equivalent in ETH for all contributions
- **Real-time Price Conversion**: Uses Chainlink price feeds for accurate ETH/USD conversion
- **Owner-only Withdrawals**: Only the contract deployer can withdraw accumulated funds
- **Gas-optimized Operations**: Includes both standard and cheaper withdrawal functions
- **Multi-network Support**: Configured for Ethereum Mainnet, Sepolia testnet, and local Anvil
- **Fallback Funding**: Accepts direct ETH transfers through fallback and receive functions

## 🛠 Tech Stack

- **Smart Contract Language**: Solidity ^0.8.18
- **Development Framework**: Foundry
- **Price Feeds**: Chainlink Aggregator V3
- **Testing**: Foundry Test Suite with Forge
- **Deployment**: Foundry Scripts with multi-network configuration
- **Development Tools**: 
  - Forge (building, testing, deploying)
  - Cast (blockchain interaction)
  - Anvil (local blockchain)

## 📋 Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
- Git installed
- An Ethereum wallet with testnet ETH for deployment

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone <your-repo-url>
cd fundme-project
```

### 2. Install Dependencies
```bash
forge install
```

### 3. Build the Project
```bash
forge build
```

### 4. Run Tests
```bash
forge test
```

### 5. Deploy Locally
```bash
# Start local blockchain
anvil

# Deploy to local network (in new terminal)
forge script script/DeployFundMe.s.sol --rpc-url http://localhost:8545 --private-key <your-private-key> --broadcast
```

## 🏗 Project Structure

```
├── src/
│   ├── FundMe.sol              # Main crowdfunding contract
│   └── PriceConverter.sol      # Library for ETH/USD price conversion
├── script/
│   ├── DeployFundMe.s.sol      # Deployment script
│   ├── HelperConfig.s.sol      # Network configuration helper
│   └── Interactions.s.sol      # Fund and withdraw interaction scripts
├── test/
│   ├── unit/
│   │   └── FundMeTest.t.sol    # Comprehensive unit tests
│   ├── integration/
│   │   └── InteractionsTest.t.sol # Integration tests
│   └── mocks/
│       └── MockV3Aggregator.sol # Mock price feed for testing
└── lib/                        # External dependencies
```

## 🔧 Core Contracts

### FundMe.sol
The main contract that handles:
- Accepting ETH donations with minimum $5 USD requirement
- Tracking funders and their contribution amounts
- Owner-only withdrawal functionality
- Gas-optimized withdrawal options

### PriceConverter.sol
A library providing:
- Real-time ETH/USD price fetching from Chainlink
- Conversion utilities for amount validation

### HelperConfig.sol
Network configuration management:
- Sepolia testnet configuration
- Ethereum mainnet configuration  
- Local Anvil mock setup

## 🧪 Testing

The project includes comprehensive testing:

### Unit Tests (`FundMeTest.t.sol`)
- Minimum funding amount validation
- Owner verification
- Price feed integration
- Fund tracking and withdrawal logic
- Gas usage optimization testing

### Integration Tests (`InteractionsTest.t.sol`)
- End-to-end funding and withdrawal flows
- Script interaction validation

### Run All Tests
```bash
# Run all tests
forge test

# Run tests with verbosity
forge test -vvv

# Run specific test
forge test --match-test testMinimumDollarIsFive

# Run tests with gas reporting
forge test --gas-report
```

## 🌐 Deployment

### Deploy to Sepolia Testnet
```bash
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

### Deploy to Ethereum Mainnet
```bash
forge script script/DeployFundMe.s.sol --rpc-url $MAINNET_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

## 🤝 Interacting with the Contract

### Fund the Contract
```bash
# Using cast
cast send <CONTRACT_ADDRESS> "fund()" --value 0.1ether --private-key $PRIVATE_KEY --rpc-url $RPC_URL

# Using interaction script
forge script script/Interactions.s.sol:FundFundMe --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

### Withdraw Funds (Owner Only)
```bash
# Using interaction script
forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

### Check Contract State
```bash
# Get contract balance
cast balance <CONTRACT_ADDRESS> --rpc-url $RPC_URL

# Get funder contribution
cast call <CONTRACT_ADDRESS> "getAddressToAmountFunded(address)" <FUNDER_ADDRESS> --rpc-url $RPC_URL

# Get contract owner
cast call <CONTRACT_ADDRESS> "getOwner()" --rpc-url $RPC_URL
```

## ⚡ Gas Optimization

The contract includes two withdrawal methods:

1. **Standard Withdraw**: Basic implementation
2. **Cheaper Withdraw**: Gas-optimized version that:
   - Caches array length to avoid repeated storage reads
   - Uses more efficient loop patterns
   - Reduces overall gas consumption for multiple funders

## 🔒 Security Features

- **Owner-only Access**: Critical functions protected by `onlyOwner` modifier
- **Custom Errors**: Gas-efficient error handling with `FundMe__NotOwner`
- **Reentrancy Protection**: Uses low-level `call` with proper checks
- **Minimum Funding**: Prevents dust transactions with USD-equivalent minimum

## 📊 Network Configuration

| Network | Chain ID | Price Feed Address |
|---------|----------|-------------------|
| Ethereum Mainnet | 1 | 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419 |
| Sepolia Testnet | 11155111 | 0x694AA1769357215DE4FAC081bf1f309aDC325306 |
| Local Anvil | 31337 | Mock Contract (deployed automatically) |

## 🔍 Key Functions

### Public Functions
- `fund()`: Accept ETH donations (minimum $5 USD equivalent)
- `withdraw()`: Owner-only standard withdrawal
- `cheaperWithdraw()`: Owner-only gas-optimized withdrawal

### View Functions
- `getAddressToAmountFunded(address)`: Get contribution amount by address
- `getFunder(uint256)`: Get funder address by index
- `getOwner()`: Get contract owner address
- `getVersion()`: Get price feed version

## 🐛 Troubleshooting

### Common Issues

1. **"You need to spend more ETH!" Error**
   - Ensure you're sending at least $5 USD equivalent in ETH
   - Check current ETH/USD price and calculate accordingly

2. **Deployment Failures**
   - Verify you have sufficient ETH for gas fees
   - Ensure your RPC URL is correct and accessible
   - Check that your private key is properly formatted

3. **Test Failures**
   - Run `forge install` to ensure all dependencies are installed
   - Verify Foundry is up to date: `foundryup`

## 📄 License

This project is licensed under the MIT License - see the contract headers for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

If you encounter any issues or have questions:
- Check the [Foundry Book](https://book.getfoundry.sh/) for framework documentation
- Review [Chainlink Documentation](https://docs.chain.link/) for price feed details
- Open an issue in this repository for project-specific problems

---

**Built with ❤️ using Foundry and Chainlink**