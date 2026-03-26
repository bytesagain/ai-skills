#!/usr/bin/env bash
# nft — NFT (Non-Fungible Token) reference tool
# Powered by BytesAgain | bytesagain.com
set -euo pipefail
VERSION="1.0.0"

cmd_intro() { cat << 'EOF'
# NFT (Non-Fungible Token) — Overview

## What is an NFT?
A Non-Fungible Token is a unique digital asset on a blockchain. Unlike
fungible tokens (ETH, USDC) where each unit is interchangeable, each NFT
has a distinct identity (contract address + token ID).

## Core Standard: ERC-721
Introduced by CryptoKitties team (2018). Key interface:
  - balanceOf(owner) → how many NFTs the address holds
  - ownerOf(tokenId) → who owns a specific token
  - transferFrom(from, to, tokenId) → move ownership
  - approve(to, tokenId) → grant transfer permission
  - setApprovalForAll(operator, bool) → blanket approval
  - tokenURI(tokenId) → metadata location (URL or IPFS hash)

## Metadata Standard
tokenURI returns a JSON file:
  {
    "name": "Cool Cat #1234",
    "description": "A unique cool cat",
    "image": "ipfs://QmX.../1234.png",
    "attributes": [
      {"trait_type": "Background", "value": "Blue"},
      {"trait_type": "Fur", "value": "Gold", "display_type": "string"}
    ]
  }

## Storage Models
  On-chain:  Metadata + image stored in contract (expensive, permanent)
  IPFS:      Content-addressed, immutable once pinned (ipfs://Qm...)
  Arweave:   Permanent storage, pay once (ar://...)
  Centralized: Regular URL (https://api.example.com/meta/1) — risky

## Minting Flow
  1. Deploy ERC-721 contract with mint function
  2. User calls mint() → pays gas + mint price
  3. Contract assigns new tokenId to caller
  4. Transfer event emitted: Transfer(address(0), minter, tokenId)
  5. Marketplaces index the Transfer event automatically

## Marketplace Mechanics
  Listing: Owner calls setApprovalForAll(marketplace, true)
  Buying:  Marketplace calls transferFrom(seller, buyer, tokenId)
  Royalty:  ERC-2981 returns (receiver, amount) for secondary sales
  Auction:  Bids held in escrow contract, highest wins after deadline
EOF
}

cmd_standards() { cat << 'EOF'
# NFT Standards Reference

## ERC-721 — Non-Fungible Token Standard (EIP-721)
  Required: balanceOf, ownerOf, safeTransferFrom, transferFrom,
            approve, getApproved, setApprovalForAll, isApprovedForAll
  Events:   Transfer(from, to, tokenId), Approval(owner, approved, tokenId)
  Optional: name(), symbol(), tokenURI(tokenId)
  Safe transfer: Receiver must implement onERC721Received() or tx reverts

## ERC-1155 — Multi Token Standard
  Single contract manages both fungible and non-fungible tokens
  balanceOf(account, id) — check balance of specific token type
  balanceOfBatch(accounts[], ids[]) — batch balance check
  safeTransferFrom(from, to, id, amount, data) — transfer any type
  uri(id) — metadata URI with {id} substitution pattern
  Use case: Game items (sword=NFT, gold=fungible, same contract)

## ERC-2981 — NFT Royalty Standard
  royaltyInfo(tokenId, salePrice) returns (receiver, royaltyAmount)
  Typical: 2.5-10% of sale price
  NOT enforced on-chain — marketplaces choose to honor or ignore
  OpenSea Operator Filter Registry: blocks marketplaces that skip royalties

## ERC-4907 — Rental NFT (Dual Role)
  setUser(tokenId, user, expires) — grant temporary usage rights
  userOf(tokenId) — current user (may differ from owner)
  userExpires(tokenId) — expiration timestamp
  Use case: Gaming item rental, metaverse land leasing

## ERC-6551 — Token Bound Accounts
  Each NFT gets its own smart contract wallet
  NFT can own other tokens, NFTs, interact with DeFi
  createAccount(implementation, chainId, tokenContract, tokenId, salt)
  Account address deterministic via CREATE2
  Use case: NFT character that carries inventory

## ERC-5192 — Minimal Soulbound Token
  locked(tokenId) returns bool — true means non-transferable
  Locked(tokenId) / Unlocked(tokenId) events
  Use case: Credentials, membership, identity

## Metadata JSON Schema
  Required: name, description, image
  Optional: external_url, animation_url, background_color
  Attributes array: trait_type, value, display_type
  display_type options: string, number, boost_number, boost_percentage, date
EOF
}

cmd_troubleshooting() { cat << 'EOF'
# NFT Troubleshooting Guide

## Metadata Not Showing on OpenSea
  Problem: Minted NFT shows blank on OpenSea
  Causes:
    - Base URI missing trailing slash: "ipfs://QmX" vs "ipfs://QmX/"
    - tokenURI returns 404 or empty JSON
    - Metadata JSON missing required fields (name, image)
    - Image URL unreachable (IPFS not pinned, server down)
  Fix:
    - Force refresh: POST api.opensea.io/api/v2/chain/ethereum/contract/{addr}/nfts/{id}/refresh
    - Verify tokenURI output: cast call <contract> "tokenURI(uint256)" <id>
    - Ensure image is accessible via public IPFS gateway

## IPFS Gateway Timeout
  Problem: ipfs://Qm... not loading or very slow
  Causes: Content not pinned, or public gateways overloaded
  Fix:
    - Pin with Pinata: pinata.cloud (free 500MB)
    - Pin with nft.storage: nft.storage (free, backed by Filecoin)
    - Use dedicated gateway: gateway.pinata.cloud/ipfs/{hash}
    - Self-host IPFS node for production

## Gas Estimation Failure on Mint
  Problem: "execution reverted" during mint
  Common causes:
    - Sale not active (check isSaleActive/isPublicSale flag)
    - Max per wallet exceeded (check maxMintPerWallet)
    - Wrong mint price (check mintPrice * quantity)
    - Allowlist not set (merkle root not configured)
    - Contract paused (check Pausable.paused())
  Debug: cast call <contract> "mint(uint256)" <qty> --value <price>

## Royalty Not Enforced
  Problem: Secondary sales on some marketplaces pay no royalty
  Reality: ERC-2981 is voluntary — marketplaces can ignore it
  Solutions:
    - Implement OperatorFilterRegistry (blocks non-royalty marketplaces)
    - Use LooksRare/X2Y2 with mandatory royalties
    - Accept that royalty enforcement is imperfect on-chain

## tokenURI Returning Wrong Data
  Problem: All tokens return same metadata or wrong token metadata
  Common bugs:
    - Hardcoded baseURI without tokenId concatenation
    - Off-by-one: tokenId starts at 0 but files start at 1
    - String concatenation: Strings.toString(tokenId) missing
    - Revealed flag not set (still returning placeholder URI)
EOF
}

cmd_performance() { cat << 'EOF'
# NFT Gas Optimization

## ERC-721A (Azuki) — Batch Mint Optimization
  Standard ERC-721: Each mint writes owner + balance = ~50k gas each
  ERC-721A: Batch of N mints costs almost same as 1 mint
  How: Only writes to first token in batch, infers rest on read
  Savings: 5 mints saves ~60% gas vs standard
  Trade-off: Slightly more gas on transfers (must update gaps)
  Install: npm install erc721a

## Lazy Minting (Mint on Purchase)
  Creator signs metadata off-chain (no gas cost)
  Buyer pays gas to mint + purchase in single transaction
  Requires: EIP-712 typed signature, voucher struct
  Flow: sign(tokenId, price, uri) → buyer calls redeem(voucher)
  Used by: Rarible, Foundation

## Merkle Proof Whitelists
  Instead of storing 10k addresses on-chain (expensive):
    1. Build Merkle tree off-chain from address list
    2. Store only 32-byte root on-chain: setMerkleRoot(bytes32)
    3. User submits proof[]: mint(proof, quantity)
    4. Contract verifies: MerkleProof.verify(proof, root, leaf)
  Gas: ~2k per proof element vs ~20k per SSTORE
  Library: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol

## Bitmap for Claimed Tracking
  Instead of mapping(address => bool) hasClaimed:
    Use bitmap: mapping(uint256 => uint256) where each bit = 1 address
    256 addresses per storage slot vs 1 per slot
    Check: (bitmap[index/256] >> (index%256)) & 1
  Savings: 256x reduction in storage slots

## SSTORE2 for On-Chain Art
  Regular SSTORE: ~20k gas per 32 bytes
  SSTORE2: Deploy data as contract bytecode via CREATE
    Read: EXTCODECOPY (much cheaper than SLOAD)
    Write once, read many pattern
  Used for: On-chain SVG, generative art parameters
  Library: solady/src/utils/SSTORE2.sol

## General Tips
  - Use uint96 for prices (fits in same slot as address)
  - Pack structs: address(20) + uint96(12) = 1 slot (32 bytes)
  - Avoid strings in events (use indexed bytes32 instead)
  - unchecked {} for counter increments (saves ~60 gas)
  - Custom errors vs require strings (saves ~200 gas per revert)
EOF
}

cmd_security() { cat << 'EOF'
# NFT Security Guide

## Reentrancy in Mint Functions
  Attack: Malicious onERC721Received callback re-enters mint()
  Impact: Mint more than maxPerWallet, drain contract
  Fix: Use ReentrancyGuard from OpenZeppelin
    import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
    function mint(uint256 qty) external payable nonReentrant { ... }
  Alternative: Checks-Effects-Interactions pattern

## Signature Replay in Allowlist Mints
  Attack: Valid signature reused across chains or after contract upgrade
  Impact: Unauthorized mints, exceed allocation
  Fix: Include in signed message:
    - chainId (prevent cross-chain replay)
    - contract address (prevent cross-contract replay)
    - nonce or deadline (prevent reuse)
    - quantity allowed (prevent over-mint)
  Use EIP-712 for structured, verifiable signatures

## Front-Running Reveal
  Attack: Attacker sees pending reveal transaction, buys rare NFTs
  How: Monitor mempool for setBaseURI/reveal transactions
  Fix: Commit-reveal pattern:
    1. Mint phase: All tokens show placeholder
    2. Commit: Owner submits hash(baseURI + secret)
    3. Reveal: Owner submits baseURI + secret (verified against hash)
    4. Randomize: Use VRF (Chainlink) for token-to-metadata mapping

## setApprovalForAll Phishing
  Attack: Malicious site asks user to setApprovalForAll(attacker, true)
  Impact: Attacker can transfer ALL user's NFTs from that collection
  Prevention:
    - Wallet warnings (MetaMask shows approval scope)
    - Users: Never approve unknown contracts
    - Devs: Consider per-token approve() instead

## Unlimited Mint Exploits
  Attack: No maxSupply check, or maxPerWallet only checks current balance
  Impact: Unlimited minting, worthless collection
  Fix:
    - require(totalSupply() + qty <= MAX_SUPPLY)
    - Use mapping for mint count (not balanceOf — user can transfer out)
    - mapping(address => uint256) private _mintCount;

## Withdrawal Vulnerabilities
  Attack: Funds locked in contract, owner can't withdraw
  Cause: Using transfer() (2300 gas limit) to multisig or contract
  Fix: Use call{value: amount}("") instead of transfer()
    (bool success, ) = payable(owner).call{value: balance}("");
    require(success, "Transfer failed");
EOF
}

cmd_migration() { cat << 'EOF'
# NFT Migration Guide

## ERC-721 to ERC-1155 Migration
  Why: Multi-edition support, gas efficiency, batch transfers
  Steps:
    1. Snapshot current holders: query Transfer events for ownership
    2. Deploy new ERC-1155 contract with equivalent token IDs
    3. Airdrop: Batch mint to all existing holders
    4. Optional: Allow burn-to-claim (burn 721, receive 1155)
    5. Update marketplace listings to new collection
    6. Redirect old tokenURI to point to new contract
  Considerations:
    - 1:1 unique NFTs use amount=1 in ERC-1155
    - Existing approvals don't carry over
    - Historical provenance stays on old contract

## Centralized Metadata to IPFS Migration
  Why: Server goes down = metadata lost forever
  Steps:
    1. Download all metadata JSON + images from current server
    2. Organize: metadata/0.json, metadata/1.json, images/0.png...
    3. Upload images to IPFS: ipfs add -r images/
    4. Update metadata JSON: replace image URLs with ipfs:// hashes
    5. Upload metadata to IPFS: ipfs add -r metadata/
    6. Pin on Pinata/nft.storage for persistence
    7. Call setBaseURI("ipfs://QmNewMetadataFolder/")
    8. Verify on OpenSea: refresh each token
  Tools:
    - nft.storage: Free permanent storage (Filecoin-backed)
    - Pinata: Free tier 500MB, paid for more
    - thirdweb Storage: SDK for automated uploads

## Marketplace Migration Checklist
  When moving from OpenSea to another marketplace:
    [ ] Verify new marketplace supports your token standard
    [ ] Check royalty enforcement policy
    [ ] Update collection metadata (banner, description, links)
    [ ] Notify community via Discord/Twitter
    [ ] Test listing and buying on testnet first
    [ ] Monitor for airdrop scams impersonating new marketplace
    [ ] Update project website marketplace links
    [ ] Consider multi-marketplace listing for max visibility
EOF
}

cmd_cheatsheet() { cat << 'EOF'
# NFT Developer Cheatsheet

## Foundry / Forge Commands
  forge init my-nft-project                   # New project
  forge install openzeppelin/openzeppelin-contracts  # Add OZ
  forge build                                  # Compile
  forge test -vvv                              # Test with traces
  forge create src/MyNFT.sol:MyNFT \
    --rpc-url $RPC --private-key $KEY \
    --constructor-args "MyNFT" "MNFT"          # Deploy
  forge verify-contract $ADDR src/MyNFT.sol:MyNFT \
    --etherscan-api-key $KEY --chain mainnet   # Verify

## Hardhat Commands
  npx hardhat compile
  npx hardhat run scripts/deploy.js --network mainnet
  npx hardhat verify --network mainnet $ADDR "MyNFT" "MNFT"

## IPFS Commands
  ipfs add -r ./metadata/                      # Upload folder
  ipfs pin add QmHash                          # Pin content
  ipfs cat QmHash/0.json                       # Read file

## OpenZeppelin Contracts Wizard
  https://wizard.openzeppelin.com/#erc721
  Generate: Mintable, Burnable, Enumerable, URIStorage, Pausable

## API Endpoints
  OpenSea (v2):
    GET api.opensea.io/api/v2/chain/ethereum/contract/{addr}/nfts/{id}
    POST api.opensea.io/api/v2/chain/ethereum/contract/{addr}/nfts/{id}/refresh

  Alchemy NFT API:
    GET {network}.g.alchemy.com/nft/v3/{key}/getNFTsForOwner?owner={addr}
    GET {network}.g.alchemy.com/nft/v3/{key}/getNFTMetadata?contractAddress={addr}&tokenId={id}

  Reservoir (aggregator):
    GET api.reservoir.tools/tokens/v7?tokens={addr}:{id}

## Block Explorers
  Ethereum: etherscan.io/token/{addr}
  Polygon:  polygonscan.com/token/{addr}
  Base:     basescan.org/token/{addr}

## Common Contract Reads
  cast call $ADDR "totalSupply()(uint256)"
  cast call $ADDR "tokenURI(uint256)(string)" 1
  cast call $ADDR "ownerOf(uint256)(address)" 1
  cast call $ADDR "balanceOf(address)(uint256)" $WALLET
  cast call $ADDR "royaltyInfo(uint256,uint256)(address,uint256)" 1 10000
EOF
}

cmd_faq() { cat << 'EOF'
# NFT — Frequently Asked Questions

Q: How much gas does minting cost?
A: Standard ERC-721 mint: ~50,000-80,000 gas (~$3-15 at typical prices).
   ERC-721A batch mint of 5: ~65,000 gas total (vs ~350,000 standard).
   ERC-1155 mint: ~26,000 gas (most efficient).
   Layer 2 (Polygon, Base): ~$0.01-0.10 per mint.

Q: Are royalties enforced on-chain?
A: Not automatically. ERC-2981 is informational only.
   OpenSea enforces via Operator Filter Registry (block non-paying
   marketplaces). Blur made royalties optional. Some chains (Stacks)
   have protocol-level royalties.

Q: What are soulbound tokens (SBTs)?
A: Non-transferable NFTs (ERC-5192). Once minted, cannot be sold or
   transferred. Use cases: university diplomas, proof of attendance
   (POAPs), professional certifications, on-chain reputation.
   Vitalik Buterin proposed them in "Decentralized Society" paper (2022).

Q: What are dynamic NFTs?
A: NFTs whose metadata changes based on external data.
   Examples: Sports NFT updates with player stats (Chainlink oracle),
   art NFT changes with weather, game character levels up.
   Implementation: On-chain SVG generation or oracle-triggered
   metadata refresh. Base URI points to API that serves dynamic JSON.

Q: How do cross-chain NFTs work?
A: LayerZero ONFT: Lock on source chain, mint on destination.
   Wormhole: Similar bridge mechanism with guardian network.
   Connext: Liquidity-based bridging for faster transfers.
   Risks: Bridge exploits, wrapped token depegs, metadata sync issues.

Q: What's the difference between ERC-721 and ERC-1155?
A: ERC-721: Each token unique, one contract per collection.
   ERC-1155: Multiple token types in one contract (unique + fungible).
   ERC-1155 is more gas efficient for batch operations.
   Choose 721 for PFP/art, 1155 for gaming/editions.

Q: How do I make my NFT collection updatable?
A: Use a proxy pattern (UUPS or Transparent Proxy) for contract logic.
   For metadata: use a revealable baseURI that owner can update.
   Warning: Upgradeable contracts reduce trust — users prefer immutable.
   Compromise: Lock metadata after reveal, keep contract logic upgradeable.

Q: What's the cheapest way to launch an NFT collection?
A: Use ERC-721A on a Layer 2 (Base, Polygon, Arbitrum).
   Tools: thirdweb (no-code), Manifold (creator tools), or custom Foundry.
   Cost breakdown: Contract deploy ~$2-5 on L2, metadata on IPFS (free).
   Total: Under $10 to launch 10,000 NFTs on L2.
EOF
}

cmd_help() {
    echo "nft v$VERSION — NFT (Non-Fungible Token) Reference Tool"
    echo ""
    echo "Usage: nft <command>"
    echo ""
    echo "Commands:"
    echo "  intro           Overview of NFTs and core concepts"
    echo "  standards       ERC-721, ERC-1155, ERC-2981 and more"
    echo "  troubleshooting Common problems and solutions"
    echo "  performance     Gas optimization techniques"
    echo "  security        Security vulnerabilities and fixes"
    echo "  migration       Migration and upgrade guides"
    echo "  cheatsheet      Quick reference commands and URLs"
    echo "  faq             Frequently asked questions"
    echo "  help            Show this help"
}

case "${1:-help}" in
    intro) cmd_intro ;;
    standards) cmd_standards ;;
    troubleshooting) cmd_troubleshooting ;;
    performance) cmd_performance ;;
    security) cmd_security ;;
    migration) cmd_migration ;;
    cheatsheet) cmd_cheatsheet ;;
    faq) cmd_faq ;;
    help|--help|-h) cmd_help ;;
    *) echo "Unknown: $1"; echo "Run: nft help" ;;
esac
