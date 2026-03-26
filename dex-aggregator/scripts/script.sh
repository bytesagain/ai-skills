#!/usr/bin/env bash
# dex-aggregator — DEX Aggregation Reference
set -euo pipefail
VERSION="4.0.0"

cmd_intro() { cat << 'EOF'
# DEX Aggregation — Overview

## What is a DEX Aggregator?
A DEX aggregator sources liquidity from multiple decentralized exchanges
to find the optimal swap route for a given trade. Instead of using one DEX,
the aggregator splits and routes your order across multiple pools.

## How Routing Works
  1. Query prices from all supported DEXs simultaneously
  2. Calculate all possible routes (direct, multi-hop, split)
  3. Account for gas costs of each route
  4. Select route with best net output (after gas and fees)
  5. Execute swap(s) in a single transaction

  Example route for 100 ETH → USDC:
    30 ETH via Uniswap V3 (0.3% pool) → 60,300 USDC
    50 ETH via Uniswap V3 (0.05% pool) → 100,450 USDC
    20 ETH via Curve tricrypto → 40,180 USDC
    Total: 200,930 USDC (vs 198,500 on single DEX = 1.2% better)

## Major Aggregators
  1inch:    Most popular, Fusion mode for gasless swaps, Pathfinder algorithm
  0x/Matcha: RFQ system for professional market makers, gasless API
  Paraswap: MultiPath algorithm, augustusSwapper contract, gas refund
  CowSwap:  Batch auctions, MEV protection, surplus to users, CoW Protocol
  Jupiter:  Solana's dominant aggregator, Limit orders, DCA, Perps
  KyberSwap: Dynamic trade routing, elastic pools, cross-chain
  ODOS:     Smart Order Routing with multi-input tokens

## Aggregator vs Direct DEX
  Aggregator advantages:
    - Better price (sourcing from all liquidity)
    - Lower slippage (splitting across pools)
    - MEV protection (some aggregators)
    - Gas optimization (batching multiple swaps)
  Direct DEX advantages:
    - Simpler (single contract interaction)
    - Known slippage (no routing complexity)
    - Lower gas for small trades (no router overhead)
  Rule: Use aggregator for trades >$1,000, direct DEX for small amounts
EOF
}

cmd_standards() { cat << 'EOF'
# Aggregator Protocol Standards

## 1inch Fusion Mode
  Gasless swaps: User signs order off-chain, resolvers execute on-chain
  Dutch auction: Price starts favorable, decreases until resolver fills
  MEV protection: Resolvers compete, MEV goes to user as better price
  No gas required: Resolver pays gas, deducted from trade output
  Architecture:
    User → Sign order → 1inch API → Resolver network → On-chain execution
  Supported chains: Ethereum, BSC, Polygon, Arbitrum, Optimism, Avalanche

## 0x RFQ (Request For Quote) System
  Professional market makers provide guaranteed quotes
  Flow: Request → Market makers bid → Best quote selected → Execute
  Advantages: No slippage, fixed price guaranteed
  Used by: Matcha, MetaMask Swaps, Coinbase Wallet, Robinhood
  Limit orders: Place orders that execute when price reaches target
  0x API: api.0x.org — most widely integrated swap API

## CowSwap Batch Auctions
  CoW (Coincidence of Wants): Match opposing trades directly
  If Alice sells ETH for USDC and Bob sells USDC for ETH → direct match
  No AMM needed, no LP fees, no price impact
  Surplus: If batch settles at better price, surplus goes to user
  MEV protection: Trades never enter public mempool
  Architecture: Users → Signed orders → Solvers compete → Best batch wins

## Paraswap MultiPath
  Algorithm: Find optimal path through any combination of DEXs
  Augustus Swapper: Modular contract, upgradeable routing logic
  Gas refund: Paraswap sometimes refunds gas in PSP tokens
  Price feed: Real-time quotes from 300+ liquidity sources
  Delta: New routing algorithm with improved path finding
EOF
}

cmd_troubleshooting() { cat << 'EOF'
# DEX Aggregator Troubleshooting

## Transaction Reverted: Common Causes
  "INSUFFICIENT_OUTPUT_AMOUNT":
    Price moved between quote and execution (slippage exceeded)
    Fix: Increase slippage tolerance (try 1-3%)
    For volatile tokens: 3-5% or use limit orders

  "TRANSFER_FROM_FAILED" or "STF":
    Token has transfer fee/tax not accounted for
    Common with: Reflection tokens, rebase tokens, fee-on-transfer
    Fix: Increase slippage to cover token tax (check tokenomics)
    Some aggregators have "Fee-on-transfer" toggle

  "DEADLINE_EXCEEDED" or "EXPIRED":
    Transaction sat in mempool too long
    Fix: Increase gas price or set longer deadline (30+ min)
    Fusion/gasless mode: Resolver didn't fill within deadline

  "EXECUTION_REVERTED" (generic):
    Debug: Check transaction on Tenderly for exact revert reason
    Common: Insufficient approval, paused contract, blacklisted address

## Price Impact Too High
  Warning: "Price impact >5%" or "High price impact"
  Cause: Trade size too large relative to pool liquidity
  Solutions:
    1. Split trade manually over time (DCA)
    2. Use limit orders (fill over time at target price)
    3. Use aggregator's built-in split across more pools
    4. Trade on a chain with deeper liquidity

## Approval Issues
  "Approve token first": Must approve aggregator router to spend tokens
  Infinite vs exact approval:
    Infinite: Approve once, trade unlimited times (convenient but risky)
    Exact: Approve only needed amount each time (safer, extra gas per trade)
  Stuck approval: If previous approval pending, need to cancel with same nonce
  Token permit: EIP-2612 tokens support gasless approval via signature
EOF
}

cmd_performance() { cat << 'EOF'
# Swap Optimization

## Optimal Split Ratios
  Why split: Large trades in one pool cause high price impact
  Aggregator algorithms: Solve optimization problem across all available pools
  Manual splitting: Trade in chunks of <1% of pool TVL for minimal impact
  Example for $500K swap:
    Single pool (TVL $10M): ~5% price impact
    Split 50/50 across two pools: ~2.5% each = less total impact
    Aggregator optimal: May find 60/25/15 split = even less impact

## Gas Estimation Accuracy
  Aggregator quotes include estimated gas cost
  Actual gas may differ: ±10-20% due to state changes
  Multi-hop trades: Each hop ~100-150K gas
  Approval transaction: ~46K gas (one-time per token per router)
  Tips:
    - Simple swap (1 hop): ~150K gas
    - 2-hop route: ~250K gas
    - Split across 3 pools: ~350K gas
    - Check if better route saves more than extra gas costs

## Partial Fill Strategies
  Some aggregators support partial fills:
    1inch Limit Order: Can be partially filled by resolvers
    CowSwap: Batch may partially fill if insufficient counterparty
    0x RFQ: Usually all-or-nothing
  Benefits: Get some execution even in thin markets
  Risk: Remaining unfilled amount needs separate execution

## Private Transaction Pools
  Problem: Public mempool exposes pending trades to MEV bots
  Solutions:
    Flashbots Protect: Submit via private mempool
    MEV Blocker: rpc.mevblocker.io custom RPC
    1inch Fusion: Resolver executes, never hits public mempool
    CowSwap: Off-chain order book, batch auction
  Setup: Add private RPC to MetaMask → Settings → Networks → RPC URL
  Trade-off: Private txs may take slightly longer to confirm
EOF
}

cmd_security() { cat << 'EOF'
# Aggregator Security

## Approval Management
  Infinite Approval Risk:
    If router contract is compromised → attacker can drain all approved tokens
    Historical incidents: Multichain (2022), Badger DAO (2021)
  Best Practice:
    - Use exact approval amounts when possible
    - Periodically revoke unused approvals (revoke.cash)
    - Only approve to audited, well-known router contracts
    - Check approval transaction before signing (verify spender address)

  Permit2 (Uniswap):
    Single approval to Permit2 contract, then per-trade signatures
    Time-limited: Set expiration on each trade approval
    Batch revoke: Revoke Permit2 once instead of per-token
    Adopted by: Uniswap, 1inch, and others

## Front-Running Protection
  Sandwich attack mechanics:
    Attacker sees pending swap → buys token → your swap executes → attacker sells
    You get worse price, attacker profits difference
  Protection layers:
    1. Private transaction submission (Flashbots, MEV Blocker)
    2. Tight slippage settings (0.5-1%)
    3. Gasless/off-chain aggregators (1inch Fusion, CowSwap)
    4. Time-weighted average price (TWAP) for large orders

## Token Contract Risks
  Before swapping unknown tokens, check:
    1. Is contract verified on Etherscan? (Unverified = red flag)
    2. Can owner pause/blacklist transfers? (Centralization risk)
    3. Are there hidden fees? (Buy/sell tax in transfer function)
    4. Is it a proxy contract? (Implementation can be changed)
    5. Check on: tokensniffer.com, gopluslabs.io, de.fi/scanner

## Router Contract Security
  Only interact with official router addresses:
    1inch v5:    0x1111111254EEB25477B68fb85Ed929f73A960582
    Uniswap V3:  0xE592427A0AEce92De3Edee1F18E0157C05861564
    0x Exchange:  0xDef1C0ded9bec7F1a1670819833240f027b25EfF
    Paraswap v5: 0xDEF171Fe48CF0115B1d80b88dc8eAB59176FEe57
  Verify by checking official documentation, not just Google results
  Phishing: Fake aggregator sites use similar-looking domains
EOF
}

cmd_migration() { cat << 'EOF'
# Migration Guide

## CEX → DEX Transition
  Why switch:
    - Self-custody (not your keys, not your coins)
    - No KYC requirement (privacy)
    - Access to long-tail tokens not listed on CEXs
    - 24/7 availability (no maintenance windows)

  Steps:
    1. Set up non-custodial wallet (MetaMask, Rabby, or hardware wallet)
    2. Withdraw funds from CEX to your wallet
    3. Choose an aggregator (1inch, CowSwap, Paraswap)
    4. Approve tokens for the router contract
    5. Start with small test swap
    6. Set appropriate slippage (0.5% for majors, 1-3% for small caps)

  CEX advantages you'll lose:
    - Limit orders (some aggregators now support this)
    - Margin/leverage (use perp DEXs: GMX, dYdX, Hyperliquid)
    - Fiat on/off-ramp (use MoonPay, Transak, or CEX for fiat only)

## Single-DEX → Aggregator
  Before: Always swap on Uniswap directly
  After: Use aggregator to get best price across all DEXs
  Result: Typically 0.5-3% better execution on mid-size trades
  No downside for large trades (aggregator always checks direct route too)
  Setup: Just use aggregator interface instead of DEX directly
  API integration: Replace Uniswap router calls with 0x/1inch API calls

## Cross-Chain Swapping
  Problem: Assets on Ethereum, want to swap on Arbitrum
  Solutions:
    1. Bridge first, then swap (two steps, more control)
    2. Cross-chain aggregators: LI.FI, Socket, Squid Router
    3. Intent-based: Across Protocol, deBridge
  LI.FI: Aggregates bridges + DEXs in single transaction
    API: li.fi/v1/quote?fromChain=1&toChain=42161&fromToken=ETH&toToken=USDC
  Risk: Cross-chain swaps involve bridge risk (added smart contract exposure)
EOF
}

cmd_cheatsheet() { cat << 'EOF'
# DEX Aggregator Quick Reference

## API Endpoints
  1inch:    https://api.1inch.dev/swap/v5.2/{chainId}/swap
  0x:       https://api.0x.org/swap/v1/quote
  Paraswap: https://apiv5.paraswap.io/prices
  CowSwap:  https://api.cow.fi/mainnet/api/v1/quote
  Jupiter:  https://quote-api.jup.ag/v6/quote
  LI.FI:    https://li.quest/v1/quote

## Common Swap Parameters
  fromToken:      Token address to sell (or "ETH" for native)
  toToken:        Token address to buy
  amount:         Amount in smallest unit (wei for ETH = amount × 10^18)
  slippage:       Tolerance in percentage (1 = 1%)
  fromAddress:    Your wallet address (for gas estimation)
  deadline:       Unix timestamp for transaction expiry

## Chain IDs
  Ethereum: 1       Arbitrum: 42161    Optimism: 10
  Polygon: 137      BSC: 56           Avalanche: 43114
  Base: 8453        zkSync: 324       Fantom: 250
  Solana: (not EVM, different APIs)

## Token Approval Commands (ethers.js)
  // Check current allowance
  const allowance = await token.allowance(owner, spenderAddress);
  // Approve exact amount
  await token.approve(spenderAddress, amount);
  // Approve unlimited (use with caution)
  await token.approve(spenderAddress, ethers.MaxUint256);
  // Revoke approval
  await token.approve(spenderAddress, 0);

## Popular Router Addresses (Ethereum)
  1inch v5:        0x1111111254EEB25477B68fb85Ed929f73A960582
  Uniswap V3:      0xE592427A0AEce92De3Edee1F18E0157C05861564
  Uniswap Universal: 0x3fC91A3afd70395Cd496C647d5a6CC9D4B2b7FAD
  0x Exchange:      0xDef1C0ded9bec7F1a1670819833240f027b25EfF
  Paraswap Augustus: 0xDEF171Fe48CF0115B1d80b88dc8eAB59176FEe57
  CowSwap Vault:   0xC92E8bdf79f0507f65a392b0ab4667716BFE0110
  Permit2:         0x000000000022D473030F116dDEE9F6B43aC78BA3
EOF
}

cmd_faq() { cat << 'EOF'
# DEX Aggregator — FAQ

Q: Do aggregators charge extra fees?
A: Most aggregators are free for basic swaps (they earn from positive slippage).
   1inch: Free API, Fusion has no gas cost, may take small spread.
   0x: Free API for DeFi, paid for commercial use (0x pricing page).
   CowSwap: No fees, protocol earns from batch surplus.
   Paraswap: Free, earns from positive slippage and PSP token utility.
   Some charge API fees for high-volume commercial integrations.

Q: Is it safe to use DEX aggregators?
A: Major aggregators (1inch, 0x, CowSwap, Paraswap) are audited.
   Risk: Smart contract bug in router contract (rare but happened).
   Risk: Approving tokens to compromised contract.
   Mitigation: Use exact approvals, revoke when done, stick to major ones.
   Never interact with aggregator links from Discord DMs or random tweets.

Q: Why did my swap give me less than quoted?
A: Price moved between quote and execution (especially in volatile markets).
   Slippage: You set 1% tolerance, price moved 0.8% → you got less.
   MEV: Sandwich attack extracted value (use private transactions).
   Gas: Quote doesn't always reflect actual gas cost perfectly.
   Check: Compare actual output vs minimum output in transaction details.

Q: How do I integrate a DEX aggregator into my app?
A: Easiest: Use 0x API or 1inch API (most documentation, SDKs).
   Steps: 1) Get API key, 2) Fetch quote, 3) Build transaction, 4) Send.
   SDKs: @0x/swap-sdk (JS), 1inch SDK, paraswap-sdk.
   Important: Handle approval flow before swap transaction.
   Test on testnet first (Goerli/Sepolia supported by most).

Q: Aggregator vs Uniswap directly — real savings?
A: Small trades (<$500): Usually same or within $1 difference.
   Medium ($500-$50K): Aggregator typically 0.3-1.5% better.
   Large ($50K+): Aggregator significantly better (split orders).
   Exotic tokens: Aggregator finds routes you wouldn't find manually.
   Always compare: Check both and use whichever gives better output.
EOF
}

cmd_help() {
    echo "dex-aggregator v$VERSION — DEX Aggregation Reference"
    echo ""
    echo "Usage: dex-aggregator <command>"
    echo ""
    echo "Commands:"
    echo "  intro           Aggregator mechanics, major platforms"
    echo "  standards       1inch Fusion, 0x RFQ, CowSwap batches"
    echo "  troubleshooting Reverted transactions, approvals, price impact"
    echo "  performance     Split ratios, gas estimation, private pools"
    echo "  security        Approvals, front-running, token risks"
    echo "  migration       CEX→DEX, single-DEX→aggregator, cross-chain"
    echo "  cheatsheet      API endpoints, chain IDs, router addresses"
    echo "  faq             Fees, safety, savings, integration"
    echo "  help            Show this help"
}

case "${1:-help}" in
    intro) cmd_intro ;; standards) cmd_standards ;;
    troubleshooting) cmd_troubleshooting ;; performance) cmd_performance ;;
    security) cmd_security ;; migration) cmd_migration ;;
    cheatsheet) cmd_cheatsheet ;; faq) cmd_faq ;;
    help|--help|-h) cmd_help ;;
    *) echo "Unknown: $1"; echo "Run: dex-aggregator help" ;;
esac
