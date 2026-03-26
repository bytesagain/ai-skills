#!/usr/bin/env bash
# blast — Blast L2 Ethereum Chain Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="2.0.1"

cmd_overview() {
    cat <<'EOF'
═══════════════════════════════════════════════════
  Blast L2 — Chain Overview
═══════════════════════════════════════════════════

【What is Blast?】
  Blast is an Ethereum L2 (Layer 2) with native yield for ETH and
  stablecoins. Built as an Optimistic Rollup, it inherits Ethereum's
  security while providing cheaper transactions and automatic yield.

  Launched: Feb 2024 (Mainnet)
  Type:     Optimistic Rollup
  Built on: Optimism Bedrock (modified)
  Creator:  Pacman (founder of Blur NFT marketplace)

【Key Chain Parameters】
  Chain ID:           81457
  Currency:           ETH (auto-rebasing)
  Block Time:         ~2 seconds
  Finality:           ~12 minutes (soft), 7 days (challenge period)
  RPC URL:            https://rpc.blast.io
  Explorer:           https://blastscan.io
  Bridge:             https://blast.io/bridge

【What Makes Blast Unique】
  1. Native Yield for ETH
     - ETH balances auto-rebase (grow over time)
     - Yield sourced from L1 ETH staking (Lido)
     - ~3-5% APY on idle ETH, zero effort

  2. Native Yield for Stablecoins (USDB)
     - USDB is Blast's native stablecoin
     - Backed by MakerDAO's T-Bill yield (sDAI)
     - ~5% APY on USDB balances

  3. Gas Revenue Sharing
     - DApps earn a share of gas fees their users pay
     - Programmable via Gas Mode settings
     - Unique revenue model for developers

  4. Blast Points & Gold
     - Points: earned by holding assets / using DApps
     - Gold: earned through DApp-specific activities
     - Distributed during airdrop seasons

【Architecture】
  ┌─────────────┐     ┌──────────────┐
  │  Ethereum L1 │◄────│  Blast L2     │
  │  (Settlement) │     │  (Execution)  │
  │              │     │              │
  │  ETH Staking │────►│  Auto-Rebase  │
  │  (Lido)      │     │  ETH Balance  │
  │              │     │              │
  │  sDAI/T-Bills│────►│  USDB Yield   │
  └─────────────┘     └──────────────┘

  Sequencer → Batch Transactions → Post to L1
  Challenge Period: 7 days (fraud proof window)

【Network Stats (approximate)】
  TVL:              $500M+ (varies)
  Daily Txns:       500K-2M
  Avg Gas Price:    0.001-0.01 gwei
  Active Addresses: 100K+ daily

📖 More skills: bytesagain.com
EOF
}

cmd_yield() {
    cat <<'EOF'
═══════════════════════════════════════════════════
  Blast Native Yield Mechanics
═══════════════════════════════════════════════════

【ETH Native Yield】
  How it works:
  1. User bridges ETH from L1 to Blast
  2. Blast stakes deposited ETH via Lido (stETH)
  3. Staking yield accrues on L1
  4. ETH balances on Blast auto-rebase to reflect yield

  Auto-Rebase Behavior:
  • Your ETH balance literally increases over time
  • No staking, wrapping, or claiming required
  • Works in EOAs and smart contracts
  • Current APY: ~3-5% (follows ETH staking rate)

  Example:
    Day 0:  You have 10.000 ETH on Blast
    Day 30: You have 10.012 ETH on Blast (at 4.5% APY)
    Day 365: You have 10.450 ETH on Blast

  ⚠️ For Smart Contracts:
    Default: yield is OFF for contracts
    Must call: IERC20Rebasing(ETH_ADDRESS).configure(YieldMode.AUTOMATIC)
    Modes:
      VOID      — No yield (default for contracts)
      AUTOMATIC — Balance auto-increases
      CLAIMABLE — Yield accrues separately, must claim

【USDB — Blast Native Stablecoin】
  How it works:
  1. User bridges USDC/USDT/DAI → converted to USDB on Blast
  2. Underlying assets deposited into MakerDAO sDAI on L1
  3. T-Bill yield accrues and rebases USDB balances

  USDB Properties:
  • 1 USDB ≈ $1.00 (soft peg via MakerDAO)
  • Auto-rebasing like ETH
  • ~5% APY (follows sDAI rate)
  • Redeems back to DAI on L1

  Smart Contract Configuration (same as ETH):
    IERC20Rebasing(USDB_ADDRESS).configure(YieldMode.AUTOMATIC)

【Yield Comparison Table】
  Asset    On Blast     Holding on L1     Difference
  ──────────────────────────────────────────────────
  ETH      3-5% APY     0% (just hold)   Free yield
  USDB     ~5% APY      —                Auto stablecoin yield
  USDC     0%           0%               (bridge converts to USDB)
  WETH     0%*          0%               (*unless using WETH rebasing)

【Gas Revenue Sharing for DApps】
  DApps deployed on Blast can claim gas revenue:

  Gas Modes:
    VOID    — Gas fees go to sequencer (default)
    CLAIMABLE — Contract owner can claim accumulated gas fees
    
  Configuration:
    IBlast(BLAST_ADDRESS).configureClaimableGas()
    IBlast(BLAST_ADDRESS).claimAllGas(contractAddr, recipient)

  Revenue potential:
    High-volume DApp (10K txns/day): ~0.5-2 ETH/month in gas revenue

【Yield Calculation Helper】
  Given: 100 ETH deposited at 4% APY

  Daily:     100 × 0.04 / 365 = 0.01096 ETH/day
  Weekly:    100 × 0.04 / 52  = 0.07692 ETH/week
  Monthly:   100 × 0.04 / 12  = 0.33333 ETH/month
  Annually:  100 × 0.04       = 4.0     ETH/year

  Compounding effect (auto-rebase compounds):
    Simple:    104.00 ETH after 1 year
    Compound:  104.08 ETH after 1 year (continuous compounding)

📖 More skills: bytesagain.com
EOF
}

cmd_gas() {
    cat <<'EOF'
═══════════════════════════════════════════════════
  Gas Costs — Blast vs L1 vs Other L2s
═══════════════════════════════════════════════════

【Blast Gas Pricing】
  Base Fee:        ~0.001 gwei (vs L1's ~20-50 gwei)
  L1 Data Fee:     Varies (calldata posted to Ethereum)
  
  Total tx cost = L2 execution fee + L1 data fee
  
  After EIP-4844 (blobs):
    L1 data fee dropped ~10-100× for all rollups
    Blast transactions: typically $0.001-$0.05

【Transaction Cost Comparison (approximate, USD)】
  Operation          Ethereum L1    Blast L2      Savings
  ────────────────────────────────────────────────────────
  ETH Transfer       $1-5           $0.001-0.01   99%+
  ERC-20 Transfer    $3-10          $0.002-0.02   99%+
  Uniswap Swap       $10-50         $0.01-0.05    99%+
  NFT Mint           $10-80         $0.01-0.10    99%+
  Contract Deploy    $50-500        $0.10-1.00    99%+

【L2 Comparison Matrix】
  Chain          Type          Gas (ETH tx)   Yield    TPS
  ──────────────────────────────────────────────────────────
  Blast          OP Rollup     $0.001-0.01    ✅ Yes   ~50
  Arbitrum One   OP Rollup     $0.001-0.05    ❌ No    ~40
  Optimism       OP Rollup     $0.001-0.05    ❌ No    ~50
  Base           OP Rollup     $0.001-0.03    ❌ No    ~50
  zkSync Era     ZK Rollup     $0.01-0.10     ❌ No    ~100
  Polygon zkEVM  ZK Rollup     $0.01-0.05     ❌ No    ~30
  StarkNet       ZK Rollup     $0.01-0.20     ❌ No    ~50

  Blast advantage: Native yield makes idle funds productive
  Blast trade-off: Centralized sequencer (like most L2s)

【Gas Optimization Tips on Blast】
  1. Batch transactions when possible
  2. L1 data fee is the main cost — minimize calldata
  3. Use events instead of storage for read-only data
  4. Pack struct fields to minimize storage slots
  5. Short-circuit conditions to save gas on reverts
  6. Use CLAIMABLE gas mode to earn back gas fees (for DApps)

【Fee Breakdown Example】
  A Uniswap V3 swap on Blast:
    L2 Execution:  ~65,000 gas × 0.001 gwei = 0.000000065 ETH
    L1 Data Fee:   ~1,500 bytes × blob cost  = 0.00001-0.0001 ETH
    Total:         ~$0.01 - $0.05

📖 More skills: bytesagain.com
EOF
}

cmd_bridge() {
    cat <<'EOF'
═══════════════════════════════════════════════════
  Blast Bridge Guide
═══════════════════════════════════════════════════

【Official Bridge: blast.io/bridge】

【Depositing (L1 → Blast)】
  Supported Assets:
    ETH   → ETH (auto-rebasing)
    USDC  → USDB (auto-rebasing stablecoin)
    USDT  → USDB
    DAI   → USDB
    WETH  → ETH

  Steps:
    1. Go to blast.io/bridge
    2. Connect wallet (MetaMask, WalletConnect, etc.)
    3. Select asset and amount
    4. Confirm L1 transaction
    5. Wait ~10-15 minutes for deposit confirmation
    6. Funds appear on Blast with auto-yield enabled

  Deposit Time: ~10-15 minutes
  Deposit Fee: L1 gas only (no bridge fee)

【Withdrawing (Blast → L1)】
  ⚠️ Optimistic Rollup withdrawal has a challenge period!

  Standard Withdrawal (official bridge):
    1. Initiate withdrawal on Blast
    2. Wait 14 days (challenge period)
    3. Prove withdrawal on L1
    4. Claim funds on L1

  Fast Withdrawal (third-party bridges):
    • Orbiter Finance   (~1-10 minutes, 0.1-0.3% fee)
    • Across Protocol   (~2-10 minutes, 0.05-0.2% fee)
    • Relay Bridge      (~1-5 minutes, variable fee)
    • Owlto Finance     (~1-5 minutes, low fee)

  USDB Withdrawal:
    USDB → bridges back to → DAI on L1

【Bridge Security Considerations】
  Official Bridge:
    ✅ Secured by Ethereum L1
    ✅ No counterparty risk
    ❌ 14-day withdrawal delay

  Third-Party Bridges:
    ✅ Fast (minutes)
    ⚠️ Smart contract risk
    ⚠️ Liquidity risk for large amounts
    ❌ Bridge fees

  Recommendations:
    • Small amounts: third-party bridge (speed)
    • Large amounts (>$50K): official bridge (security)
    • Always verify bridge contract addresses
    • Start with small test transaction

【Adding Blast to MetaMask】
  Network Name:    Blast
  RPC URL:         https://rpc.blast.io
  Chain ID:        81457
  Currency:        ETH
  Explorer:        https://blastscan.io

  Alternative RPCs:
    https://rpc.ankr.com/blast
    https://blast.din.dev/rpc
    https://blastl2-mainnet.public.blastapi.io

【Programmatic Bridging】
  // Using Blast Bridge SDK / direct contract
  // Deposit contract on L1: 0x3...
  // 
  // Simple ETH deposit:
  //   Call deposit() with msg.value on L1 bridge contract
  //
  // ERC-20 deposit:
  //   1. approve(bridgeAddress, amount) on L1
  //   2. depositERC20(tokenL1, tokenL2, amount, gasLimit, data)

📖 More skills: bytesagain.com
EOF
}

cmd_ecosystem() {
    cat <<'EOF'
═══════════════════════════════════════════════════
  Blast Ecosystem — Key Projects & DApps
═══════════════════════════════════════════════════

【DEXes / AMMs】
  Thruster        — Leading DEX on Blast (Uni V2/V3 style)
  Hyperlock       — Liquidity management & yield aggregator
  BladeSwap       — DEX with concentrated liquidity
  Ring Protocol   — Orderbook DEX
  MonoSwap        — Community DEX

【Lending / Borrowing】
  Juice Finance   — Leveraged yield farming
  Orbit Protocol  — Lending/borrowing with native yield
  Pac Finance     — Money market protocol
  Particle        — Leverage trading protocol
  Segment Finance — Lending with yield integration

【NFTs / Gaming】
  Fantasy Top     — SocialFi trading card game
  Munchables      — Play-to-earn game (Blast native)
  YOLO Games      — Risk-based gaming
  BAM             — NFT marketplace

【Yield / DeFi】
  EtherFi         — Liquid restaking on Blast
  Renzo           — ezETH restaking
  Kelp DAO        — rsETH on Blast
  Wasabi Protocol — Perps & options
  ZeroLend        — Lending protocol

【Infrastructure】
  Blastscan       — Block explorer (by Etherscan)
  Blast API       — RPC endpoints
  Pyth Network    — Oracle feeds on Blast
  Gelato          — Automation / relayer
  Conduit         — RaaS (Rollup as a Service)

【Bridges】
  Blast Bridge    — Official (14-day withdrawal)
  Orbiter Finance — Fast bridge
  Across Protocol — Fast bridge
  Relay Bridge    — Fast bridge
  Owlto Finance   — Cross-chain bridge

【Unique Blast Features for Developers】
  1. Gas Revenue Sharing
     DApps claim gas fees from their user transactions.

  2. Yield Primitives
     Smart contracts opt into ETH/USDB yield.
     New DeFi composability: yield-bearing base assets.

  3. Blast Points API
     DApps distribute Blast Points to their users.
     Incentive alignment between protocol and DApps.

【Developer Quick Start】
  1. Add Blast network to Hardhat/Foundry
  2. Deploy contracts (EVM compatible, Solidity works)
  3. Configure yield mode for your contracts
  4. Set up gas revenue claiming
  5. Integrate Blast Points distribution
  6. Verify on Blastscan

  Tooling: Hardhat, Foundry, Remix, thirdweb all work
  Language: Solidity (same as Ethereum L1)

📖 More skills: bytesagain.com
EOF
}

cmd_help() {
    cat <<EOF
Blast v${VERSION} — Ethereum L2 Chain Reference

Commands:
  overview        Chain architecture, specs, and design philosophy
  yield           Native yield mechanics (ETH, USDB, gas sharing)
  gas             Gas costs comparison with L1 and other L2s
  bridge          Bridging guide (deposit, withdraw, third-party)
  ecosystem       Blast ecosystem projects and key DApps
  help            Show this help
  version         Show version

Usage:
  bash scripts/script.sh overview
  bash scripts/script.sh yield
  bash scripts/script.sh gas

Key Links:
  Website:    https://blast.io
  Bridge:     https://blast.io/bridge
  Explorer:   https://blastscan.io
  Docs:       https://docs.blast.io

Related skills:
  clawhub install cairo
  clawhub install solidity
Browse all: bytesagain.com

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    overview)    cmd_overview ;;
    yield)       cmd_yield ;;
    gas)         cmd_gas ;;
    bridge)      cmd_bridge ;;
    ecosystem)   cmd_ecosystem ;;
    version)     echo "blast v${VERSION}" ;;
    help|*)      cmd_help ;;
esac
