# 🎰 Decentralized Lottery Smart Contract

[![Solidity](https://img.shields.io/badge/Solidity-0.8.19-blue.svg)](https://soliditylang.org/)
[![Foundry](https://img.shields.io/badge/Built%20with-Foundry-orange.svg)](https://getfoundry.sh/)
[![Chainlink VRF](https://img.shields.io/badge/Powered%20by-Chainlink%20VRF-blue.svg)](https://chain.link/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> A provably fair, decentralized lottery system powered by Chainlink VRF v2.5 for verifiable randomness and Chainlink Keepers for automated execution.

## 🚀 Overview

This project implements a fully decentralized lottery system where players can enter by paying an entrance fee, and a winner is selected using Chainlink's verifiable random function (VRF). The lottery runs automatically at specified intervals using Chainlink Keepers, ensuring complete trustlessness and transparency.

### ✨ Key Features

- **🎲 Provably Fair Randomness**: Utilizes Chainlink VRF v2.5 for cryptographically secure random number generation
- **⚡ Automated Execution**: Chainlink Keepers automatically trigger lottery drawings at preset intervals
- **🔒 Trustless & Transparent**: No admin controls - everything runs on smart contracts
- **💰 Fair Distribution**: Winner takes the entire prize pool
- **🛡️ Battle-Tested**: Comprehensive test suite with 100% coverage
- **🌐 Multi-Network Support**: Deployable on Ethereum mainnet, testnets, and local development networks

## 🏗️ Architecture

The project follows a modular architecture with clear separation of concerns:

```
src/
├── Raffle.sol              # Main lottery contract
script/
├── DeployRaffle.s.sol      # Deployment script
├── HelperConfig.s.sol      # Network configuration management
└── Interactions.s.sol      # VRF subscription management
test/
├── RaffleTest.t.sol        # Comprehensive test suite
└── mocks/
    └── LinkToken.sol       # Mock LINK token for testing
```

## 🎯 How It Works

1. **Entry Phase**: Players enter the raffle by sending ETH equal to the entrance fee
2. **Automated Trigger**: Chainlink Keepers monitor the contract and trigger the lottery when conditions are met:
   - Specified time interval has passed
   - Raffle is in OPEN state
   - Contract has a balance > 0
   - At least one player has entered
3. **Random Selection**: Chainlink VRF generates a verifiable random number
4. **Winner Selection**: The random number is used to select a winner from the player array
5. **Prize Distribution**: The entire contract balance is automatically sent to the winner
6. **Reset**: The raffle resets for the next round

## 🛠️ Technology Stack

- **Smart Contracts**: Solidity 0.8.19
- **Development Framework**: Foundry
- **Random Number Generation**: Chainlink VRF v2.5
- **Automation**: Chainlink Keepers
- **Testing**: Foundry's testing framework with Forge
- **Network Support**: Ethereum Sepolia, Mainnet, Local Anvil

## 📋 Prerequisites

- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Foundry](https://getfoundry.sh/)

## 🚀 Quick Start

### Installation

```bash
git clone https://github.com/yourusername/smart-contract-lottery
cd smart-contract-lottery
forge install
```

### Configuration

1. Create a `.env` file with your configuration:
```bash
SEPOLIA_RPC_URL=your_sepolia_rpc_url
PRIVATE_KEY=your_private_key
ETHERSCAN_API_KEY=your_etherscan_api_key
```

2. Set up Chainlink VRF subscription at [vrf.chain.link](https://vrf.chain.link)

### Deploy to Local Network

```bash
# Start local Anvil node
anvil

# Deploy contracts
forge script script/DeployRaffle.s.sol --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
```

### Deploy to Sepolia Testnet

```bash
forge script script/DeployRaffle.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

## 🧪 Testing

Run the comprehensive test suite:

```bash
# Run all tests
forge test

# Run tests with verbosity
forge test -vvv

# Run specific test
forge test --match-test testRaffleInitializesInOpenState

# Check test coverage
forge coverage
```

### Test Coverage

The project maintains comprehensive test coverage including:
- Unit tests for all contract functions
- Integration tests with Chainlink VRF
- Edge case handling
- Reentrancy protection
- State transitions

## 📊 Contract Details

### Main Functions

| Function | Description | Visibility |
|----------|-------------|------------|
| `enterRaffle()` | Enter the lottery by paying entrance fee | External, Payable |
| `checkUpkeep()` | Check if lottery conditions are met | Public, View |
| `performUpkeep()` | Trigger the lottery drawing | External |
| `fulfillRandomWords()` | Handle VRF callback and select winner | Internal |

### State Variables

- `i_entranceFee`: Fixed entrance fee to participate
- `i_interval`: Time interval between lottery rounds
- `s_players`: Dynamic array of participants
- `s_raffleState`: Current state (OPEN/CALCULATING)
- `s_recentWinner`: Address of the most recent winner

### Events

- `RaffleEntered(address indexed player)`: Emitted when a player enters
- `WinnerPicked(address indexed winner)`: Emitted when winner is selected
- `RequestRaffleWinner(uint256 indexed requestId)`: Emitted when VRF request is made

## 🔐 Security Features

- **Reentrancy Protection**: Uses CEI (Checks-Effects-Interactions) pattern
- **Access Control**: State-based access control prevents unauthorized actions
- **Randomness**: Cryptographically secure randomness via Chainlink VRF
- **Automated Execution**: Reduces human intervention and potential manipulation

## 💰 Gas Optimization

The contract is optimized for gas efficiency:
- Uses `immutable` variables for constants
- Efficient array operations
- Minimal storage reads/writes
- Optimized random number usage

## 🌍 Network Configuration

The project supports multiple networks with automatic configuration:

| Network | Chain ID | VRF Coordinator | Key Hash |
|---------|----------|-----------------|----------|
| Sepolia | 11155111 | 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B | 0x787d74caea... |
| Local | 31337 | Mock Contract | Test Hash |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Run tests (`forge test`)
4. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
5. Push to the branch (`git push origin feature/AmazingFeature`)
6. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Chainlink](https://chain.link/) for providing decentralized oracle services
- [Foundry](https://getfoundry.sh/) for the amazing development framework
- [OpenZeppelin](https://openzeppelin.com/) for security best practices

## 📞 Contact

**Rudray Dave** -   rdiscoding@gmail.com

Repository Link: [https://github.com/RDisCoding/Blockchain.git]

---

*Built with ❤️ and lots of ☕ by Rudray Dave*