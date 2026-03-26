#!/usr/bin/env bash
# wallet-tracker — Crypto Wallet Analytics Reference
set -euo pipefail
VERSION="5.0.0"

cmd_intro() { cat << 'EOF'
# Crypto Wallet Analytics — Overview

## Wallet Types
  EOA (Externally Owned Account):
    Controlled by private key, no code, sends transactions
    Example: MetaMask, Trust Wallet, hardware wallet addresses
    Ethereum: 20-byte address, starts with 0x

  Contract Wallet (Smart Account):
    Code-based wallet with programmable logic
    Gnosis Safe: Multi-signature, threshold signing (e.g., 2-of-3)
    ERC-4337 Account Abstraction: Gasless transactions, social recovery
    Argent: Guardian-based recovery without seed phrase

  Multisig Wallet:
    Requires M-of-N signatures to execute transactions
    Common setups: 2-of-3 (personal), 3-of-5 (DAO treasury)
    Gnosis Safe (now Safe{Wallet}): Most popular, 50B+ TVL secured
    Benefits: No single point of failure, shared custody

## On-Chain Analytics
  Wallet clustering: Group addresses belonging to same entity
  Transaction graph analysis: Map fund flows between wallets
  Entity labeling: Tag known wallets (exchanges, protocols, whales)
  Behavioral analysis: Trading patterns, DeFi usage, gas spending
  Key providers: Nansen, Arkham Intelligence, Chainalysis, Dune Analytics

## Key Metrics Per Wallet
  Net worth (USD equivalent across all chains)
  Token diversity (number of distinct tokens held)
  Transaction frequency and volume
  DeFi positions (lending, staking, LP positions)
  NFT holdings and floor value
  Gas spent (total and average per transaction)
  First/last activity timestamps
  Counterparty analysis (most interacted addresses)
EOF
}

cmd_standards() { cat << 'EOF'
# Address Formats & Standards

## Bitcoin Address Formats
  P2PKH (Legacy):  Starts with "1"   Example: 1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa
    Base58Check encoded, 25-34 characters
    Script: OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG

  P2SH (Script):   Starts with "3"   Example: 3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy
    Used for multisig and SegWit-compatible (P2SH-P2WPKH)
    Script hash: HASH160 of the redeem script

  Bech32 (SegWit):  Starts with "bc1q"  Example: bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq
    BIP-173, lowercase only, 42/62 characters (P2WPKH/P2WSH)
    Bech32m for Taproot: bc1p... (BIP-350)

  Taproot (P2TR):   Starts with "bc1p"  Example: bc1p5d7rjq7g6rdk2yhzks9smlaqtedr4dekq08ge8ztwac72sfr9rusxg3297
    BIP-341, Schnorr signatures, key/script path spending

## Ethereum Address Format
  20 bytes hex: 0x followed by 40 hexadecimal characters
  EIP-55 Checksum: Mixed-case encoding for error detection
    0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed (checksummed)
  All-lowercase also valid but no error detection

## Solana Address Format
  Base58 encoded Ed25519 public key, 32-44 characters
  Example: 9WzDXwBbmkg8ZTbNMqUxvQRAyrZzDsGYdLVL9zYtAWWM
  No checksum in address itself (validated at protocol level)

## Multi-Chain Address Derivation (BIP-44)
  Path: m / purpose' / coin_type' / account' / change / index
  Bitcoin:  m/44'/0'/0'/0/0  (or m/84' for native SegWit)
  Ethereum: m/44'/60'/0'/0/0
  Solana:   m/44'/501'/0'/0'
  Cosmos:   m/44'/118'/0'/0/0
EOF
}

cmd_troubleshooting() { cat << 'EOF'
# Wallet Troubleshooting Guide

## Missing Transactions
  Symptom: Sent tokens but recipient doesn't see them
  Checks:
    1. Verify correct network (Ethereum mainnet vs Arbitrum vs BSC)
    2. Check transaction hash on block explorer (etherscan.io)
    3. Token may need to be manually added to wallet (custom token)
    4. Internal transactions (contract calls) don't show in basic view
    5. For ERC-20: Check Transfer event logs, not transaction value
  Common cause: Sent ETH on Arbitrum but recipient checked Ethereum mainnet

## Wrong Network
  Problem: Sent USDC on Polygon but gave Ethereum address
  Reality: Same address works on all EVM chains — funds are on Polygon
  Fix: Add Polygon network to wallet, tokens will appear
  Exception: Sending to a smart contract address that doesn't exist on target chain
    — Funds recoverable only if contract is deployed to same address on that chain

## Stuck Pending Transaction
  Cause: Gas price too low, nonce gap, or network congestion
  Fix for MetaMask:
    1. Speed Up: Resubmit same nonce with higher gas (1.5x-2x)
    2. Cancel: Send 0 ETH to yourself with same nonce + higher gas
    3. Reset: Settings → Advanced → Reset Account (clears local nonce)
  Fix for hardware wallet: Use MEW/MyCrypto to submit replacement tx

## Gas Estimation Failures
  Error: "Gas estimation failed" or "execution reverted"
  Causes:
    - Insufficient token approval for DEX swap
    - Slippage too low for volatile token
    - Contract paused or blacklisted address
    - Insufficient ETH for gas (even when swapping tokens)
  Debug: Use Tenderly.co to simulate transaction and see exact revert reason

## Hardware Wallet Connection Issues
  Ledger not detected: Update Ledger Live, enable "Contract Data" in app settings
  Trezor bridge: Install/update Trezor Bridge service
  MetaMask + Ledger: Use "WebHID" connection method (not U2F)
  Transaction signing timeout: Check device screen for confirmation prompt
EOF
}

cmd_performance() { cat << 'EOF'
# Wallet Analytics Performance

## Batch RPC Calls
  Problem: Checking 100 token balances = 100 RPC calls
  Solution: Use multicall contract (MakerDAO Multicall3)
    Address: 0xcA11bde05977b3631167028862bE2a173976CA11 (all EVM chains)
    Batch unlimited balanceOf calls into single eth_call
    Latency: 1 RPC call vs 100, ~50ms vs ~5000ms

## Indexer vs Direct Node
  Direct Node (eth_getLogs, eth_getTransactionReceipt):
    - Real-time, no dependency, but slow for historical queries
    - Rate limited on free RPC (Infura: 100K req/day, Alchemy: 300M CU/mo)

  Indexer (The Graph, Goldsky, Ponder):
    - Pre-indexed, fast queries, GraphQL API
    - Subgraph sync delay: 5-30 seconds behind chain
    - Best for: Historical data, complex queries, dashboard analytics

  Covalent/Moralis: REST API over indexed data
    - Token balances, transaction history, NFT metadata in one call
    - Free tier: 5-10 req/second

## WebSocket vs Polling
  WebSocket (eth_subscribe):
    - Real-time: new blocks, pending transactions, log events
    - Connection: wss://eth-mainnet.alchemyapi.io/v2/{key}
    - Best for: Live wallet monitoring, whale alerts
    - Caveat: Connection drops need reconnection logic

  Polling (eth_getBlockByNumber):
    - Interval: Every 12 seconds (Ethereum block time)
    - Simpler implementation, works behind corporate proxies
    - Higher latency, more RPC calls consumed

## Multi-Chain Wallet Tracking
  Portfolio aggregation platforms: DeBank, Zapper, Zerion
  API approach: One API call per chain per wallet
  Optimization: Cache balances, poll only on new block
  Cross-chain identity: ENS, Lens Profile, Farcaster ID
EOF
}

cmd_security() { cat << 'EOF'
# Wallet Security Reference

## Private Key Management
  NEVER share: Private key, seed phrase (12/24 words), keystore password
  Storage hierarchy (most to least secure):
    1. Hardware wallet (Ledger/Trezor): Keys never leave device
    2. Air-gapped signing (Keystone, AirGap): QR-code based
    3. Mobile wallet with Secure Enclave (iPhone) / TEE (Android)
    4. Browser extension (MetaMask): Keys in encrypted local storage
    5. Hot wallet on server: Highest risk, use only for automation

  Seed phrase backup:
    - Metal plate (Cryptosteel, Billfodl): Fire/water resistant
    - Split with Shamir Secret Sharing (2-of-3 pieces)
    - Never store digitally (no cloud, no photo, no notes app)

## Token Approval Security
  Risk: Unlimited approval = contract can drain all tokens
  Check: revoke.cash or etherscan.io/tokenapprovalchecker
  Best practice: Approve exact amount, not type(uint256).max
  Revoke: Call approve(spender, 0) for unused protocols
  Permit2 (Uniswap): Time-limited approvals, single contract

## Social Engineering Attacks
  Fake customer support: "Share your screen" → steal seed phrase
  Discord DM scams: "Claim your airdrop" → phishing site
  Address poisoning: Attacker sends $0 from similar address → victim copies wrong address
  Clipboard hijacking: Malware replaces copied address with attacker's
  Prevention: Verify address character-by-character, use address book, hardware wallet

## Approval Revocation Checklist
  When to revoke:
    - After using a DEX/DeFi protocol you won't use again
    - If protocol is compromised (check rekt.news)
    - Regularly audit (monthly) all active approvals
  Cost: Standard ETH revocation tx costs ~$2-5 in gas
  Tools: revoke.cash (free), Etherscan token approval checker
EOF
}

cmd_migration() { cat << 'EOF'
# Wallet Migration Guide

## Single-Sig → Multisig Migration
  Why: Eliminate single point of failure, shared control
  Steps:
    1. Deploy Safe{Wallet} at safe.global (free)
    2. Set owners: Hardware wallet + mobile + backup key
    3. Set threshold: 2-of-3 recommended for personal
    4. Transfer assets from EOA to Safe address
    5. Update DeFi positions to new address
    6. Move governance delegations (Snapshot, on-chain)
  Cost: Safe deployment ~$20-50 in gas (Ethereum mainnet)
  Note: Some protocols don't support contract wallet interaction

## Hot Wallet → Cold Storage
  Steps:
    1. Set up hardware wallet (Ledger/Trezor)
    2. Write down seed phrase on metal plate
    3. Verify seed phrase by recovering on second device
    4. Send small test transaction from hot to cold
    5. Transfer remaining assets after confirmation
    6. Keep small ETH in hot wallet for gas

  Amount guidelines:
    Cold storage: >90% of holdings (long-term)
    Hot wallet:   <10% (active trading/DeFi)
    Hardware:     Any amount >$1,000

## Single-Chain → Multi-Chain
  Problem: Assets only on Ethereum mainnet (high gas)
  Solution: Bridge to L2s (Arbitrum, Optimism, Base, zkSync)
  Native bridges (safest): bridge.arbitrum.io, app.optimism.io
  Third-party bridges (faster): Across, Stargate, LayerZero
  Risks: Bridge hacks (Ronin $625M, Wormhole $320M)
  Best practice: Use native bridges for large amounts, wait for finality

## Exchange → Self-Custody
  Steps:
    1. Set up wallet (MetaMask/Rabby for daily, Ledger for storage)
    2. Whitelist withdrawal address on exchange
    3. Withdraw small test amount first
    4. Wait for confirmation (BTC: 6 blocks, ETH: 12 blocks)
    5. Withdraw remaining after test succeeds
    6. Record transaction hash for tax records
  Warning: "Not your keys, not your coins" — but also your responsibility
EOF
}

cmd_cheatsheet() { cat << 'EOF'
# Wallet Analytics — Quick Reference

## Block Explorer URLs
  Ethereum:  etherscan.io/address/{addr}
  Bitcoin:   mempool.space/address/{addr}
  Polygon:   polygonscan.com/address/{addr}
  Arbitrum:  arbiscan.io/address/{addr}
  Solana:    solscan.io/account/{addr}
  BSC:       bscscan.com/address/{addr}
  Base:      basescan.org/address/{addr}
  Avalanche: snowtrace.io/address/{addr}

## Etherscan API Quick Reference
  Base URL: api.etherscan.io/api
  Balance:    ?module=account&action=balance&address={addr}
  Tx List:    ?module=account&action=txlist&address={addr}&startblock=0
  Token Tx:   ?module=account&action=tokentx&address={addr}
  Token Bal:  ?module=account&action=tokenbalance&contractaddress={token}&address={addr}
  Gas Price:  ?module=gastracker&action=gasoracle
  Rate limit: 5 calls/sec (free key), 10 calls/sec (Pro)

## Popular Dune Queries
  Wallet Profiler:  dune.com/queries/1637344
  Token Holdings:   dune.com/queries/2058337
  Gas Spent:        dune.com/queries/1746389
  DEX Activity:     dune.com/queries/2437841
  SQL pattern:      SELECT * FROM ethereum.transactions WHERE "from" = {{wallet}}

## Analytics Platforms Comparison
  Nansen:     Institutional-grade, wallet labels, smart money tracking ($150/mo)
  Arkham:     Entity intelligence, alert system, free tier available
  DeBank:     Portfolio tracking, chain coverage, social features (free)
  Zapper:     DeFi positions, NFTs, multichain dashboard (free)
  Zerion:     Portfolio + trading, mobile app, clean UI (free)
  Dune:       Custom SQL queries on blockchain data (free + Pro)

## Notable Whale Addresses
  Vitalik:        0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045
  Justin Sun:     0x3DdfA8eC3052539b6C9549F12cEA2C295cfF5296
  Binance Hot:    0x28C6c06298d514Db089934071355E5743bf21d60
  Coinbase:       0x71660c4005BA85c37ccec55d0C4493E66Fe775d3
  FTX Exploiter:  0x59ABf3837Fa962d6853b4Cc0a19513AA031fd32b

## Quick Balance Check (curl)
  curl "https://api.etherscan.io/api?module=account&action=balance&address=0x...&tag=latest&apikey=YOUR_KEY"
EOF
}

cmd_faq() { cat << 'EOF'
# Wallet Analytics — FAQ

Q: How do I find who owns a wallet address?
A: Blockchain addresses are pseudonymous, not anonymous.
   Tools: Nansen (labeled wallets), Arkham (entity intelligence),
   Etherscan labels (exchange, fund, protocol addresses).
   ENS reverse lookup: Check if address has .eth name.
   On-chain sleuthing: Follow fund flows to known exchanges.
   Caveat: Deanonymization without consent may violate privacy laws.

Q: How accurate are "whale alert" services?
A: Major whale moves are generally accurate (large exchange transfers).
   False positives: Exchange internal transfers, contract interactions.
   Services like Whale Alert track known exchange hot/cold wallets.
   For CEX deposits: Look for deposits to known exchange addresses.
   For smart money: Nansen labels are ~85% accurate for major entities.

Q: How do I track a wallet across multiple chains?
A: Same EOA address works on all EVM chains (Ethereum/Polygon/Arbitrum/BSC).
   Portfolio trackers: DeBank API, Zapper API, Moralis API.
   Non-EVM chains (Bitcoin, Solana): Separate addresses, need separate tracking.
   Unified view: DeBank.com shows 50+ EVM chains in one dashboard.

Q: What happens if I send tokens to the wrong address?
A: If sent to valid address you don't control: Irreversible on-chain.
   If sent to contract without withdrawal function: Permanently lost.
   If sent to correct address wrong chain: Add that network, tokens are there.
   If sent to burn address (0x000...): Permanently lost.
   Prevention: Always send small test transaction first.

Q: How do I check if a token contract is safe?
A: Check contract on: tokensniffer.com (scam score), gopluslabs.io (security API).
   Red flags: Honeypot (can buy but not sell), hidden mint function, proxy contract
   with unverified implementation, owner can pause transfers, tax >10%.
   Verified contract on Etherscan is minimum requirement but not sufficient.
EOF
}

cmd_help() {
    echo "wallet-tracker v$VERSION — Crypto Wallet Analytics Reference"
    echo ""
    echo "Usage: wallet-tracker <command>"
    echo ""
    echo "Commands:"
    echo "  intro           Wallet types, on-chain analytics overview"
    echo "  standards       Address formats (BTC/ETH/SOL), BIP-44 paths"
    echo "  troubleshooting Missing transactions, wrong network, stuck tx"
    echo "  performance     Batch RPC, indexers, WebSocket vs polling"
    echo "  security        Private keys, approvals, social engineering"
    echo "  migration       Single→multisig, hot→cold, exchange→self-custody"
    echo "  cheatsheet      Explorers, APIs, Dune queries, whale addresses"
    echo "  faq             Wallet tracking, whale alerts, safety checks"
    echo "  help            Show this help"
}

case "${1:-help}" in
    intro) cmd_intro ;; standards) cmd_standards ;;
    troubleshooting) cmd_troubleshooting ;; performance) cmd_performance ;;
    security) cmd_security ;; migration) cmd_migration ;;
    cheatsheet) cmd_cheatsheet ;; faq) cmd_faq ;;
    help|--help|-h) cmd_help ;;
    *) echo "Unknown: $1"; echo "Run: wallet-tracker help" ;;
esac
