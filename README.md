# Escrow Smart Contract

<div align="center">
  <a href="https://docs.soliditylang.org/en/v0.8.20/"><img src="https://img.shields.io/badge/Solidity-0.8.20-363636?style=for-the-badge&logo=solidity" alt="Solidity"></a>
  <a href="https://hardhat.org/"><img src="https://img.shields.io/badge/Hardhat-Framework-yellow?style=for-the-badge&logo=hardhat" alt="Hardhat"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge" alt="License"></a>
  <a href="https://hardhat.org/hardhat-network/docs"><img src="https://img.shields.io/badge/Network-Local-green?style=for-the-badge" alt="Network"></a>
  <a href="https://en.wikipedia.org/wiki/Escrow"><img src="https://img.shields.io/badge/Pattern-Escrow-purple?style=for-the-badge" alt="Pattern"></a>
  <a href="https://ethereum.org/"><img src="https://img.shields.io/badge/Ethereum-Blockchain-627EEA?style=for-the-badge&logo=ethereum" alt="Ethereum"></a>
</div>

<div align="center">
  <h3>A trustless escrow system for secure peer-to-peer transactions</h3>
  <p>Eliminates the need for intermediaries while ensuring transaction safety</p>
  
  <br>
  
  <a href="#overview">Overview</a> •
  <a href="#features">Features</a> •
  <a href="#getting-started">Getting Started</a> •
  <a href="#deployment">Deployment</a> •
  <a href="#usage-examples">Usage</a> •
  <a href="#state-machine">State Machine</a> •
  <a href="#author">Author</a>
  
  <br><br>
  
  <img src="https://img.shields.io/github/last-commit/Siddheshwar-cloud/escrow-contract?style=flat-square" alt="Last Commit">
  <img src="https://img.shields.io/github/languages/code-size/Siddheshwar-cloud/escrow-contract?style=flat-square" alt="Code Size">
  <img src="https://img.shields.io/github/languages/top/Siddheshwar-cloud/escrow-contract?style=flat-square" alt="Top Language">
</div>

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [How Escrow Works](#how-escrow-works)
- [State Machine](#state-machine)
- [Architecture](#architecture)
- [Workflow](#workflow)
- [Getting Started](#getting-started)
- [Contract Details](#contract-details)
- [Deployment](#deployment)
- [Usage Examples](#usage-examples)
- [Security Analysis](#security-analysis)
- [Use Cases](#use-cases)
- [Author](#author)

---

## Overview

The Escrow Smart Contract provides a decentralized, trustless solution for conducting secure transactions between two parties. This contract acts as a neutral third party, holding funds until predetermined conditions are met.

### Key Highlights

- **Trustless Transactions**: No intermediary required
- **State-Based Logic**: Four clear states with controlled transitions
- **Time-Locked Refunds**: Automatic refund after deadline
- **Buyer Protection**: Buyer controls fund release and refunds
- **Zero Fees**: No middleman fees, only gas costs
- **Transparent**: All actions on-chain

---

## Features

| Feature | Description |
|---------|-------------|
| **State Management** | Four states ensure proper transaction flow |
| **Fund Locking** | Securely holds ETH until conditions met |
| **Buyer Control** | Buyer initiates all key actions |
| **Deadline Protection** | Time-based refund mechanism |
| **Immutable Parties** | Buyer and seller set at deployment |

---

## How Escrow Works

### Traditional vs Smart Contract Escrow

<div align="center">

```mermaid
graph LR
    subgraph Traditional
        A1[Buyer] -->|Pay + Fee| B1[Escrow Agent]
        B1 -->|Hold| B1
        B1 -->|Release| C1[Seller]
    end
    
    subgraph Smart Contract
        A2[Buyer] -->|Deposit ETH| B2[Contract]
        B2 -->|Auto Hold| B2
        A2 -->|Approve| B2
        B2 -->|Transfer| C2[Seller]
    end
    
    style B1 fill:#F44336
    style B2 fill:#4CAF50
```

</div>

---

## State Machine

<div align="center">

```mermaid
stateDiagram-v2
    [*] --> AWAITING_PAYMENT: Deploy
    AWAITING_PAYMENT --> FUNDED: fund()
    FUNDED --> RELEASED: release()
    FUNDED --> REFUNDED: refund()
    RELEASED --> [*]
    REFUNDED --> [*]
```

</div>

| State | Description | Actions Allowed |
|-------|-------------|-----------------|
| **AWAITING_PAYMENT** | Waiting for deposit | `fund()` |
| **FUNDED** | ETH locked | `release()`, `refund()` |
| **RELEASED** | Paid to seller | None |
| **REFUNDED** | Returned to buyer | None |

---

## Architecture

<div align="center">

```mermaid
graph TB
    A[ESCROW] --> B[State Variables]
    B --> C[buyer]
    B --> D[seller]
    B --> E[amount]
    B --> F[deadline]
    B --> G[state]
    
    A --> H[Functions]
    H --> I[fund]
    H --> J[release]
    H --> K[refund]
    
    style A fill:#4CAF50
```

</div>

---

## Workflow

### Complete Transaction Flow

<div align="center">

```mermaid
sequenceDiagram
    participant B as Buyer
    participant E as Escrow
    participant S as Seller
    
    B->>E: Deploy(seller, duration)
    B->>E: fund() + ETH
    E->>E: state = FUNDED
    S->>B: Deliver service
    B->>E: release()
    E->>S: Transfer ETH
    E->>E: state = RELEASED
```

</div>

---

## Getting Started

### Prerequisites

- Node.js v16+
- npm or yarn
- Git
- Hardhat

### Installation

```bash
# Clone repository
git clone https://github.com/Siddheshwar-cloud/escrow-contract.git
cd escrow-contract

# Install dependencies
npm install
```

### Project Structure

```
escrow-contract/
├── contracts/
│   └── ESCROW.sol
├── scripts/
│   └── deploy.js
├── hardhat.config.js
└── README.md
```

---

## Contract Details

### State Variables

```solidity
address public buyer;
address public seller;
uint256 public amount;
uint256 public deadline;
State public state;
```

### Constructor

```solidity
constructor(address _seller, uint256 _duration)
```

Sets buyer (deployer), seller, and deadline.

### Functions

#### fund()
```solidity
function fund() external payable onlybuyer inState(State.AWAITING_PAYMENT)
```
Buyer deposits ETH into escrow.

#### release()
```solidity
function release() external onlybuyer inState(State.FUNDED)
```
Buyer releases payment to seller.

#### refund()
```solidity
function refund() external onlybuyer inState(State.FUNDED)
```
Buyer reclaims funds after deadline.

---

## Deployment

### Local Network

```bash
# Terminal 1: Start node
npx hardhat node

# Terminal 2: Deploy
npx hardhat run scripts/deploy.js --network localhost
```

### Configuration

Modify in `deploy.js`:
```javascript
const duration = 60 * 60;  // 1 hour
const seller = "0xYourSellerAddress";
```

---

## Usage Examples

### Complete Transaction

```javascript
const { ethers } = require("hardhat");

async function main() {
  const [buyer, seller] = await ethers.getSigners();
  
  // Deploy
  const Escrow = await ethers.getContractFactory("ESCROW");
  const escrow = await Escrow.deploy(seller.address, 3600);
  await escrow.waitForDeployment();
  
  // Fund
  await escrow.fund({ value: ethers.parseEther("1.0") });
  console.log("Funded 1 ETH");
  
  // Release
  await escrow.release();
  console.log("Released to seller");
}

main();
```

### Refund Scenario

```javascript
async function refundExample() {
  const [buyer, seller] = await ethers.getSigners();
  
  // Deploy with 10 second deadline
  const Escrow = await ethers.getContractFactory("ESCROW");
  const escrow = await Escrow.deploy(seller.address, 10);
  await escrow.waitForDeployment();
  
  // Fund
  await escrow.fund({ value: ethers.parseEther("0.5") });
  
  // Wait for deadline
  await new Promise(r => setTimeout(r, 11000));
  
  // Refund
  await escrow.refund();
  console.log("Refunded to buyer");
}
```

### Check Status

```javascript
async function checkStatus(escrowAddress) {
  const escrow = await ethers.getContractAt("ESCROW", escrowAddress);
  
  const buyer = await escrow.buyer();
  const seller = await escrow.seller();
  const amount = await escrow.amount();
  const deadline = await escrow.deadline();
  const state = await escrow.state();
  
  console.log("Buyer:", buyer);
  console.log("Seller:", seller);
  console.log("Amount:", ethers.formatEther(amount), "ETH");
  console.log("Deadline:", new Date(Number(deadline) * 1000));
  console.log("State:", ["AWAITING", "FUNDED", "RELEASED", "REFUNDED"][state]);
}
```

---

## Security Analysis

### Access Control

| Function | Access | Protection |
|----------|--------|------------|
| `fund()` | Buyer Only | `onlybuyer` modifier |
| `release()` | Buyer Only | `onlybuyer` modifier |
| `refund()` | Buyer Only | `onlybuyer` + deadline check |

### Security Features

1. **State Machine**: Prevents invalid transitions
2. **Buyer Control**: Only buyer can execute critical functions
3. **Time Protection**: Refund only after deadline
4. **CEI Pattern**: State changes before transfers
5. **Solidity 0.8.20**: Built-in overflow protection

### Risk Assessment

| Risk | Level | Mitigation |
|------|-------|------------|
| Reentrancy | LOW | State changes first |
| Access Control | SECURE | Strict modifiers |
| State Manipulation | SECURE | State machine |
| Deadline Bypass | SECURE | Timestamp check |

---

## Use Cases

### 1. Freelance Services
Client pays freelancer via escrow. Payment released upon delivery or refunded if not delivered.

### 2. E-Commerce
Buyer deposits payment. Releases upon receiving product or refunds if not shipped.

### 3. Service Agreements
Milestone-based payments for contractors with deadline protection.

### 4. Rental Deposits
Security deposits held in escrow, returned when lease ends or used for damages.

### 5. Event Tickets
Ticket payments held until event occurs or refunded if cancelled.

---

## Comparison Table

| Aspect | Traditional Escrow | Smart Contract |
|--------|-------------------|----------------|
| Fees | 3-5% | Gas only |
| Speed | Days | Minutes |
| Trust | Required | Trustless |
| Automation | Manual | Automatic |
| Availability | Business hours | 24/7 |
| Global | Limited | Yes |

---

## Technology Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| Solidity | ^0.8.20 | Contract language |
| Hardhat | Latest | Development |
| Ethers.js | v6 | Interactions |
| Node.js | v16+ | Runtime |

---

## Best Practices

### For Buyers
- Set reasonable deadlines
- Verify seller address
- Test with small amounts first
- Document agreements off-chain
- Monitor deadline expiry

### For Sellers
- Confirm escrow funded before delivering
- Deliver before deadline
- Communicate with buyer
- Keep delivery proof
- Request release promptly

---

## Troubleshooting

**"You are Not a buyer"**
- Only deployer can call functions
- Check you're using correct account

**"Invalid state"**
- Ensure contract in correct state
- Check state with `escrow.state()`

**"Too early"**
- Deadline hasn't passed yet
- Check deadline with `escrow.deadline()`

**"Transfer Failed"**
- Recipient cannot receive ETH
- Check recipient has receive/fallback

---

## FAQ

**Q: Can seller withdraw directly?**
A: No, only buyer can release payment.

**Q: What if buyer never releases or refunds?**
A: After deadline, buyer can refund. Before deadline, funds remain locked.

**Q: Can deadline be extended?**
A: No, deadline set at deployment is immutable.

**Q: Can I cancel before funding?**
A: Yes, just don't call `fund()`.

**Q: Are multiple escrows per contract possible?**
A: No, one escrow per deployment. Deploy new contract for each escrow.

---

## Author

<div align="center">
  
  <img src="https://img.shields.io/badge/Crafted%20with-❤️-red?style=for-the-badge" alt="Made with Love">
  <img src="https://img.shields.io/badge/Built%20by-Sidheshwar%20Yengudle-blue?style=for-the-badge" alt="Author">
  
</div>

<br>

<div align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=28&pause=1000&color=2E9EF7&center=true&vCenter=true&width=600&lines=Blockchain+Developer;Smart+Contract+Engineer;Web3+Enthusiast;Solidity+Expert" alt="Typing SVG" />
</div>

<br>

<table align="center">
  <tr>
    <td align="center" width="200">
      <img src="https://img.icons8.com/fluency/96/000000/github.png" width="50" alt="GitHub"/>
      <br><strong>GitHub</strong>
      <br><a href="https://github.com/Siddheshwar-cloud">@Siddheshwar-cloud</a>
    </td>
    <td align="center" width="200">
      <img src="https://img.icons8.com/fluency/96/000000/linkedin.png" width="50" alt="LinkedIn"/>
      <br><strong>LinkedIn</strong>
      <br><a href="https://www.linkedin.com/in/sidheshwar-yengudle-113882241/">Connect</a>
    </td>
    <td align="center" width="200">
      <img src="https://img.icons8.com/fluency/96/000000/twitter.png" width="50" alt="Twitter"/>
      <br><strong>Twitter</strong>
      <br><a href="https://x.com/SYangudale">@SYangudale</a>
    </td>
  </tr>
</table>

<div align="center">
  
  <br>
  
  [![GitHub](https://img.shields.io/badge/GitHub-Siddheshwar--cloud-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Siddheshwar-cloud)
  [![LinkedIn](https://img.shields.io/badge/LinkedIn-Sidheshwar%20Yengudle-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/sidheshwar-yengudle-113882241/)
  [![Twitter](https://img.shields.io/badge/Twitter-@SYangudale-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://x.com/SYangudale)

</div>

<br>

<div align="center">

### Skills & Expertise

<img src="https://skillicons.dev/icons?i=solidity,ethereum,nodejs,javascript,typescript,git,github,vscode&theme=dark" alt="Skills"/>

</div>

---

## Show Your Support

<div align="center">
  
[![GitHub Star](https://img.shields.io/github/stars/Siddheshwar-cloud/escrow-contract?style=social)](https://github.com/Siddheshwar-cloud/escrow-contract)

<a href="https://github.com/Siddheshwar-cloud/escrow-contract/stargazers">
  <img src="https://img.shields.io/badge/⭐_Star_This_Repository-100000?style=for-the-badge&logo=github&logoColor=white" alt="Star">
</a>

**Your star helps others discover secure escrow patterns!**

</div>

### Repository Links

<div align="center">

[![View](https://img.shields.io/badge/View-Repository-black?style=for-the-badge&logo=github)](https://github.com/Siddheshwar-cloud/escrow-contract)
[![Fork](https://img.shields.io/badge/Fork-Repository-green?style=for-the-badge&logo=github)](https://github.com/Siddheshwar-cloud/escrow-contract/fork)
[![Issues](https://img.shields.io/badge/Report-Issues-red?style=for-the-badge&logo=github)](https://github.com/Siddheshwar-cloud/escrow-contract/issues)
[![PRs](https://img.shields.io/badge/Submit-PR-orange?style=for-the-badge&logo=github)](https://github.com/Siddheshwar-cloud/escrow-contract/pulls)

</div>

---

## Contributing

Contributions welcome! Feel free to:

1. Fork the project
2. Create feature branch (`git checkout -b feature/Enhancement`)
3. Commit changes (`git commit -m 'Add enhancement'`)
4. Push to branch (`git push origin feature/Enhancement`)
5. Open Pull Request

---

## License

MIT License - see [LICENSE](LICENSE) file

```
Copyright (c) 2024 Sidheshwar Yengudle
```

---

<div align="center">
  <p>Made with dedication to blockchain security</p>
  <p>Deployed on Local Hardhat Network</p>
  
  <br>
  
  <img src="https://img.shields.io/badge/🔒-Secure%20by%20Design-4CAF50?style=for-the-badge" alt="Secure">
  <img src="https://img.shields.io/badge/✅-State%20Machine-2196F3?style=for-the-badge" alt="State Machine">
  <img src="https://img.shields.io/badge/⏰-Time%20Locked-FF9800?style=for-the-badge" alt="Time Locked">
  
  <br><br>
  
  **Trustless Escrow, Safer Transactions!**
  
  <br>
  
  <a href="https://github.com/Siddheshwar-cloud/escrow-contract">
    <img src="https://img.shields.io/badge/⬆️_Back_to_Top-100000?style=for-the-badge&logo=github&logoColor=white" alt="Back to Top">
  </a>
  
  <br><br>
  
  Made with ❤️ and ☕ by Sidheshwar Yengudle © 2024
  
  <br><br>
  
  <a href="https://github.com/Siddheshwar-cloud">
    <img src="https://img.shields.io/badge/More_Projects-Explore-blue?style=for-the-badge&logo=github" alt="More Projects">
  </a>
  
</div>
