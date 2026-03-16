#!/usr/bin/env bash
# Token Launcher — Create and deploy tokens on various chains
# Usage: bash token.sh <command> [options]
# Commands: create, check, liquidity, audit, template, compare
set -euo pipefail

COMMAND="${1:-help}"
shift 2>/dev/null || true

case "$COMMAND" in
  create)
    TOKEN_NAME="${1:-MyToken}"
    TOKEN_SYMBOL="${2:-MTK}"
    TOTAL_SUPPLY="${3:-1000000}"
    CHAIN="${4:-solana}"
    DECIMALS="${5:-9}"
    TAX_BUY="${6:-0}"
    TAX_SELL="${7:-0}"
    
    python3 << 'PYEOF'
import json, sys, os, time

name = os.environ.get("TOKEN_NAME", sys.argv[1] if len(sys.argv) > 1 else "MyToken")
symbol = os.environ.get("TOKEN_SYMBOL", sys.argv[2] if len(sys.argv) > 2 else "MTK")
supply = os.environ.get("TOTAL_SUPPLY", sys.argv[3] if len(sys.argv) > 3 else "1000000")
chain = os.environ.get("CHAIN", sys.argv[4] if len(sys.argv) > 4 else "solana")
decimals = os.environ.get("DECIMALS", sys.argv[5] if len(sys.argv) > 5 else "9")
tax_buy = os.environ.get("TAX_BUY", sys.argv[6] if len(sys.argv) > 6 else "0")
tax_sell = os.environ.get("TAX_SELL", sys.argv[7] if len(sys.argv) > 7 else "0")

supply_int = int(supply)
decimals_int = int(decimals)
tax_buy_f = float(tax_buy)
tax_sell_f = float(tax_sell)

chain_configs = {
    "solana": {
        "platform": "Pump.fun / Raydium",
        "deploy_cost": "~0.02 SOL",
        "speed": "~400ms finality",
        "token_standard": "SPL Token",
        "liquidity_options": ["Raydium AMM", "Orca Whirlpools", "Meteora"],
        "tools": ["spl-token CLI", "Anchor framework", "Pump.fun UI"],
        "notes": "Pump.fun is the easiest for meme tokens. Raydium for serious projects."
    },
    "ethereum": {
        "platform": "Uniswap / Custom ERC-20",
        "deploy_cost": "~0.05-0.5 ETH (gas dependent)",
        "speed": "~12s finality",
        "token_standard": "ERC-20",
        "liquidity_options": ["Uniswap V3", "SushiSwap", "Balancer"],
        "tools": ["Remix IDE", "Hardhat", "Foundry"],
        "notes": "High gas costs. Consider L2s for cheaper deployment."
    },
    "base": {
        "platform": "Uniswap on Base / Aerodrome",
        "deploy_cost": "~0.001 ETH",
        "speed": "~2s finality",
        "token_standard": "ERC-20",
        "liquidity_options": ["Aerodrome", "Uniswap V3", "BaseSwap"],
        "tools": ["Remix IDE", "Hardhat", "Foundry"],
        "notes": "Very cheap deployment. Growing DeFi ecosystem."
    },
    "bsc": {
        "platform": "PancakeSwap",
        "deploy_cost": "~0.01 BNB",
        "speed": "~3s finality",
        "token_standard": "BEP-20",
        "liquidity_options": ["PancakeSwap V3", "BiSwap", "BabySwap"],
        "tools": ["Remix IDE", "Hardhat"],
        "notes": "Cheap but high scam risk perception. Good for Asian markets."
    }
}

config = chain_configs.get(chain, chain_configs["solana"])

# Token distribution analysis
distributions = {
    "fair_launch": {"team": 0, "liquidity": 100, "marketing": 0, "reserve": 0},
    "standard": {"team": 10, "liquidity": 60, "marketing": 15, "reserve": 15},
    "vc_backed": {"team": 15, "liquidity": 40, "marketing": 20, "reserve": 25},
    "meme": {"team": 5, "liquidity": 85, "marketing": 5, "reserve": 5}
}

# Security checklist
security_checks = [
    {"item": "Renounce ownership after launch", "risk": "HIGH", "required": True},
    {"item": "Lock liquidity (min 6 months)", "risk": "HIGH", "required": True},
    {"item": "No mint function or disabled", "risk": "HIGH", "required": True},
    {"item": "Tax under 5% each way", "risk": "MEDIUM", "required": False},
    {"item": "No blacklist function", "risk": "MEDIUM", "required": False},
    {"item": "Max wallet limit (anti-whale)", "risk": "LOW", "required": False},
    {"item": "Anti-bot measures for launch", "risk": "LOW", "required": False},
    {"item": "Verified contract on explorer", "risk": "HIGH", "required": True},
    {"item": "Audit by reputable firm", "risk": "MEDIUM", "required": False},
    {"item": "Multisig for team wallet", "risk": "MEDIUM", "required": False}
]

# Cost estimation
if chain == "solana":
    est_cost_usd = 3.0
elif chain == "ethereum":
    est_cost_usd = 150.0
elif chain == "base":
    est_cost_usd = 2.0
elif chain == "bsc":
    est_cost_usd = 5.0
else:
    est_cost_usd = 10.0

liq_suggestion = supply_int * 0.6
liq_usd_min = 1000 if chain == "solana" else 5000

print("=" * 60)
print("TOKEN LAUNCH CONFIGURATION")
print("=" * 60)
print("")
print("Token Details:")
print("  Name: {}".format(name))
print("  Symbol: {}".format(symbol))
print("  Total Supply: {:,}".format(supply_int))
print("  Decimals: {}".format(decimals_int))
print("  Buy Tax: {}%".format(tax_buy_f))
print("  Sell Tax: {}%".format(tax_sell_f))
print("")
print("Chain: {} ({})".format(chain.upper(), config["token_standard"]))
print("  Platform: {}".format(config["platform"]))
print("  Deploy Cost: {}".format(config["deploy_cost"]))
print("  Finality: {}".format(config["speed"]))
print("  Tools: {}".format(", ".join(config["tools"])))
print("")
print("-" * 60)
print("SUGGESTED TOKEN DISTRIBUTION")
print("-" * 60)
for dist_name, dist in distributions.items():
    team_tokens = supply_int * dist["team"] // 100
    liq_tokens = supply_int * dist["liquidity"] // 100
    mkt_tokens = supply_int * dist["marketing"] // 100
    res_tokens = supply_int * dist["reserve"] // 100
    print("")
    print("  {} Model:".format(dist_name.replace("_", " ").title()))
    print("    Team: {:,} ({}%)".format(team_tokens, dist["team"]))
    print("    Liquidity: {:,} ({}%)".format(liq_tokens, dist["liquidity"]))
    print("    Marketing: {:,} ({}%)".format(mkt_tokens, dist["marketing"]))
    print("    Reserve: {:,} ({}%)".format(res_tokens, dist["reserve"]))

print("")
print("-" * 60)
print("SECURITY CHECKLIST")
print("-" * 60)
for check in security_checks:
    status = "[REQUIRED]" if check["required"] else "[OPTIONAL]"
    print("  {} {} — Risk: {}".format(status, check["item"], check["risk"]))

print("")
print("-" * 60)
print("COST ESTIMATE")
print("-" * 60)
print("  Deployment: ~${:.0f}".format(est_cost_usd))
print("  Initial Liquidity: ~${:,} minimum recommended".format(liq_usd_min))
print("  Marketing Budget: ~$500-5000 recommended")
print("  Total Minimum: ~${:,}".format(int(est_cost_usd + liq_usd_min + 500)))
print("")
print("LAUNCH STEPS:")
steps = [
    "1. Prepare token metadata (name, symbol, logo, website)",
    "2. Deploy contract on {}".format(chain),
    "3. Verify contract on block explorer",
    "4. Add initial liquidity ({})".format(config["liquidity_options"][0]),
    "5. Lock liquidity (use Team.Finance or Unicrypt)",
    "6. Renounce contract ownership",
    "7. Submit to CoinGecko / CoinMarketCap",
    "8. Begin marketing campaign",
    "9. Monitor trading activity",
    "10. Engage community (Telegram, Discord, Twitter)"
]
for step in steps:
    print("  {}".format(step))

print("")
print("NOTES: {}".format(config["notes"]))

# Save config
config_out = {
    "name": name,
    "symbol": symbol,
    "totalSupply": supply_int,
    "decimals": decimals_int,
    "chain": chain,
    "taxBuy": tax_buy_f,
    "taxSell": tax_sell_f,
    "estimatedCostUSD": est_cost_usd,
    "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
}
config_path = os.path.expanduser("~/.token-launcher")
if not os.path.exists(config_path):
    os.makedirs(config_path)
with open(os.path.join(config_path, "last-config.json"), "w") as f:
    json.dump(config_out, f, indent=2)
print("")
print("Config saved to ~/.token-launcher/last-config.json")
PYEOF
    ;;

  check)
    CONTRACT="${1:-}"
    CHAIN="${2:-ethereum}"
    
    python3 << 'PYEOF'
import sys, os
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

contract = sys.argv[1] if len(sys.argv) > 1 else os.environ.get("CONTRACT", "")
chain = sys.argv[2] if len(sys.argv) > 2 else os.environ.get("CHAIN", "ethereum")

if not contract:
    print("Usage: bash token.sh check <contract_address> [chain]")
    print("Chains: ethereum, bsc, base, polygon, arbitrum")
    sys.exit(1)

# Basic contract validation
checks = []

# Length check
if len(contract) == 42 and contract.startswith("0x"):
    checks.append(("Address format", "PASS", "Valid EVM address format"))
elif len(contract) >= 32:
    checks.append(("Address format", "PASS", "Possible Solana address"))
else:
    checks.append(("Address format", "FAIL", "Invalid address length"))

# Honeypot detection heuristics
honeypot_indicators = [
    "Can buyers sell tokens after purchase?",
    "Is there a max transaction limit?",
    "Are there hidden fees on transfer?",
    "Is the contract verified on explorer?",
    "Has ownership been renounced?",
    "Is liquidity locked?",
    "Are there blacklist functions?",
    "Can the owner mint new tokens?",
    "Is there a trading cooldown?",
    "Are there proxy/upgradeable patterns?"
]

api_endpoints = {
    "ethereum": "https://api.etherscan.io/api",
    "bsc": "https://api.bscscan.com/api",
    "base": "https://api.basescan.org/api",
    "polygon": "https://api.polygonscan.com/api",
    "arbitrum": "https://api.arbiscan.io/api"
}

explorer_urls = {
    "ethereum": "https://etherscan.io/address/{}".format(contract),
    "bsc": "https://bscscan.com/address/{}".format(contract),
    "base": "https://basescan.org/address/{}".format(contract),
    "polygon": "https://polygonscan.com/address/{}".format(contract),
    "arbitrum": "https://arbiscan.io/address/{}".format(contract)
}

print("=" * 60)
print("TOKEN SECURITY CHECK")
print("=" * 60)
print("")
print("Contract: {}".format(contract))
print("Chain: {}".format(chain))
print("Explorer: {}".format(explorer_urls.get(chain, "N/A")))
print("")
print("-" * 60)
print("AUTOMATED CHECKS")
print("-" * 60)
for c in checks:
    icon = "✅" if c[1] == "PASS" else "❌"
    print("  {} {} — {}".format(icon, c[0], c[2]))
print("")
print("-" * 60)
print("MANUAL VERIFICATION CHECKLIST")
print("-" * 60)
for i, indicator in enumerate(honeypot_indicators, 1):
    print("  {}. [ ] {}".format(i, indicator))
print("")
print("RECOMMENDED TOOLS:")
tools = [
    "- TokenSniffer: https://tokensniffer.com/token/{}".format(contract),
    "- GoPlus Security: https://gopluslabs.io/token-security/{}".format(contract),
    "- DexScreener: https://dexscreener.com/search?q={}".format(contract),
    "- RugCheck (Solana): https://rugcheck.xyz/tokens/{}".format(contract),
    "- Honeypot.is: https://honeypot.is/?address={}".format(contract)
]
for tool in tools:
    print("  {}".format(tool))
print("")
print("⚠️  DISCLAIMER: Automated checks cannot guarantee safety.")
print("   Always DYOR and start with small amounts.")
PYEOF
    ;;

  liquidity)
    TOKEN="${1:-}"
    AMOUNT="${2:-1000}"
    CHAIN="${3:-solana}"
    
    python3 << 'PYEOF'
import sys, os

token = sys.argv[1] if len(sys.argv) > 1 else "TOKEN"
amount = float(sys.argv[2]) if len(sys.argv) > 2 else 1000
chain = sys.argv[3] if len(sys.argv) > 3 else "solana"

# Liquidity provision guide
dex_guides = {
    "solana": {
        "primary": "Raydium",
        "alternatives": ["Orca", "Meteora", "Pump.fun"],
        "pair_with": "SOL",
        "steps": [
            "1. Go to raydium.io/create-pool",
            "2. Connect wallet (Phantom/Solflare)",
            "3. Select token pair: {} / SOL".format(token),
            "4. Set initial price and token amounts",
            "5. Set fee tier (0.25% standard)",
            "6. Approve and create pool",
            "7. Lock LP tokens via Streamflow or Jupiter Lock",
            "8. Share pool address with community"
        ],
        "lock_tools": ["Streamflow Finance", "Jupiter Lock", "Squads Multisig"],
        "min_liq": 500
    },
    "ethereum": {
        "primary": "Uniswap V3",
        "alternatives": ["SushiSwap", "Balancer"],
        "pair_with": "ETH/WETH",
        "steps": [
            "1. Go to app.uniswap.org/add",
            "2. Connect wallet (MetaMask/Rainbow)",
            "3. Select token pair: {} / ETH".format(token),
            "4. Choose fee tier (0.3% standard, 1% for volatile)",
            "5. Set price range (full range for new tokens)",
            "6. Enter token amounts",
            "7. Approve token spending",
            "8. Add liquidity",
            "9. Lock LP NFT via Team.Finance or Unicrypt"
        ],
        "lock_tools": ["Team.Finance", "Unicrypt", "FlokiFi Locker"],
        "min_liq": 5000
    },
    "base": {
        "primary": "Aerodrome",
        "alternatives": ["Uniswap V3", "BaseSwap"],
        "pair_with": "ETH/WETH",
        "steps": [
            "1. Go to aerodrome.finance/liquidity",
            "2. Connect wallet",
            "3. Select token pair: {} / WETH".format(token),
            "4. Choose pool type (volatile or stable)",
            "5. Enter amounts",
            "6. Approve and deposit",
            "7. Stake LP for AERO rewards",
            "8. Lock via Team.Finance"
        ],
        "lock_tools": ["Team.Finance", "Unicrypt"],
        "min_liq": 1000
    },
    "bsc": {
        "primary": "PancakeSwap V3",
        "alternatives": ["BiSwap", "BabySwap"],
        "pair_with": "BNB/WBNB",
        "steps": [
            "1. Go to pancakeswap.finance/add",
            "2. Connect wallet",
            "3. Select pair: {} / BNB".format(token),
            "4. Choose fee tier",
            "5. Set price range",
            "6. Add liquidity",
            "7. Lock LP via DxSale or PinkSale"
        ],
        "lock_tools": ["DxSale", "PinkSale", "Team.Finance"],
        "min_liq": 2000
    }
}

guide = dex_guides.get(chain, dex_guides["solana"])

# Impermanent loss calculation
il_scenarios = [
    (1.25, 0.6),
    (1.5, 2.0),
    (2.0, 5.7),
    (3.0, 13.4),
    (4.0, 20.0),
    (5.0, 25.5),
    (0.5, 5.7),
    (0.25, 20.0)
]

print("=" * 60)
print("LIQUIDITY PROVISION GUIDE")
print("=" * 60)
print("")
print("Token: {}".format(token))
print("Chain: {}".format(chain.upper()))
print("Amount: ${:,.0f}".format(amount))
print("DEX: {} (primary)".format(guide["primary"]))
print("Pair with: {}".format(guide["pair_with"]))
print("")
print("-" * 60)
print("STEP-BY-STEP")
print("-" * 60)
for step in guide["steps"]:
    print("  {}".format(step))
print("")
print("Alternative DEXes: {}".format(", ".join(guide["alternatives"])))
print("")
print("-" * 60)
print("LP LOCKING (CRITICAL!)")
print("-" * 60)
print("  Recommended tools: {}".format(", ".join(guide["lock_tools"])))
print("  Minimum lock period: 6 months")
print("  Recommended: 12 months or permanent burn")
print("  Minimum liquidity: ${:,}".format(guide["min_liq"]))
print("")
print("-" * 60)
print("IMPERMANENT LOSS TABLE")
print("-" * 60)
print("  {:>15} {:>15}".format("Price Change", "IL %"))
print("  " + "-" * 30)
for ratio, il in il_scenarios:
    direction = "+" if ratio > 1 else ""
    pct = (ratio - 1) * 100
    print("  {:>14.0f}% {:>14.1f}%".format(pct, il))
print("")
if amount > 0:
    for ratio, il in [(2.0, 5.7), (5.0, 25.5)]:
        loss = amount * il / 100
        print("  If price {}x: you lose ${:,.0f} to IL on ${:,.0f}".format(ratio, loss, amount))
print("")
print("⚠️  Always lock liquidity to build community trust!")
PYEOF
    ;;

  audit)
    python3 << 'PYEOF'
print("=" * 60)
print("TOKEN LAUNCH AUDIT CHECKLIST")
print("=" * 60)
print("")

categories = {
    "Smart Contract Security": [
        ("Contract verified on block explorer", "CRITICAL"),
        ("No mint function (or permanently disabled)", "CRITICAL"),
        ("Ownership renounced or multisig", "CRITICAL"),
        ("No proxy/upgradeable patterns", "HIGH"),
        ("No hidden transfer fees", "HIGH"),
        ("No blacklist/whitelist functions", "HIGH"),
        ("No pause/unpause ability", "MEDIUM"),
        ("No self-destruct function", "CRITICAL"),
        ("Reentrancy protection", "HIGH"),
        ("Integer overflow protection", "MEDIUM")
    ],
    "Liquidity & Trading": [
        ("Liquidity locked (min 6 months)", "CRITICAL"),
        ("Adequate initial liquidity", "HIGH"),
        ("Reasonable max transaction limit", "MEDIUM"),
        ("No trading cooldown manipulation", "MEDIUM"),
        ("Slippage within normal range", "HIGH"),
        ("Listed on DEX screeners", "MEDIUM")
    ],
    "Team & Transparency": [
        ("Team members doxxed or KYC'd", "HIGH"),
        ("Clear roadmap published", "MEDIUM"),
        ("Active social media presence", "MEDIUM"),
        ("Telegram/Discord community", "LOW"),
        ("Regular development updates", "MEDIUM"),
        ("Treasury wallet transparent", "HIGH")
    ],
    "Tokenomics": [
        ("Fair token distribution", "HIGH"),
        ("Vesting schedule for team tokens", "HIGH"),
        ("Total tax under 10%", "HIGH"),
        ("No hidden fee mechanisms", "CRITICAL"),
        ("Anti-whale measures", "MEDIUM"),
        ("Deflationary mechanism (if claimed)", "LOW")
    ],
    "Legal & Compliance": [
        ("Not classified as security", "HIGH"),
        ("Terms of service published", "MEDIUM"),
        ("Privacy policy available", "LOW"),
        ("Jurisdiction disclosed", "MEDIUM"),
        ("Risk disclaimer visible", "HIGH")
    ]
}

total_items = 0
for category, items in categories.items():
    print("{}:".format(category))
    for item, severity in items:
        icon = "🔴" if severity == "CRITICAL" else "🟡" if severity == "HIGH" else "🟢"
        print("  {} [ ] {} [{}]".format(icon, item, severity))
        total_items += 1
    print("")

print("-" * 60)
print("Total items: {}".format(total_items))
print("🔴 CRITICAL: Must pass before launch")
print("🟡 HIGH: Strongly recommended")
print("🟢 MEDIUM/LOW: Nice to have")
PYEOF
    ;;

  template)
    CHAIN="${1:-solana}"
    
    python3 << 'PYEOF'
import sys

chain = sys.argv[1] if len(sys.argv) > 1 else "solana"

templates = {
    "solana": '''// Solana SPL Token Creation (using spl-token CLI)
// Prerequisites: solana-cli, spl-token-cli installed

// 1. Create token mint
// spl-token create-token --decimals 9

// 2. Create token account
// spl-token create-account <TOKEN_MINT>

// 3. Mint tokens
// spl-token mint <TOKEN_MINT> 1000000

// 4. Set metadata (using Metaplex)
// Requires: @metaplex-foundation/mpl-token-metadata

// Pump.fun alternative (easiest):
// 1. Go to pump.fun
// 2. Connect Phantom wallet
// 3. Fill in token details
// 4. Pay ~0.02 SOL
// 5. Token is live immediately
''',
    "ethereum": '''// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    uint256 public maxWalletSize;
    uint256 public maxTransactionAmount;
    
    constructor(
        string memory name,
        string memory symbol,
        uint256 totalSupply
    ) ERC20(name, symbol) Ownable(msg.sender) {
        maxWalletSize = totalSupply * 2 / 100; // 2% max wallet
        maxTransactionAmount = totalSupply * 1 / 100; // 1% max tx
        _mint(msg.sender, totalSupply * 10**decimals());
    }
    
    function renounceOwnership() public override onlyOwner {
        super.renounceOwnership();
    }
}

// Deploy with Hardhat:
// npx hardhat run scripts/deploy.js --network mainnet
''',
    "base": '''// Same as Ethereum ERC-20 but deployed on Base
// Use Hardhat with Base network config:
//
// networks: {
//   base: {
//     url: "https://mainnet.base.org",
//     accounts: [PRIVATE_KEY],
//     gasPrice: 1000000, // 0.001 Gwei
//   }
// }
//
// Deploy cost: ~$1-2 vs $100+ on Ethereum
''',
    "bsc": '''// Same as Ethereum ERC-20 but deployed on BSC
// Use Hardhat with BSC network config:
//
// networks: {
//   bsc: {
//     url: "https://bsc-dataseed.binance.org/",
//     accounts: [PRIVATE_KEY],
//     gasPrice: 5000000000, // 5 Gwei
//   }
// }
'''
}

template = templates.get(chain, templates["solana"])
print("=" * 60)
print("TOKEN CONTRACT TEMPLATE — {}".format(chain.upper()))
print("=" * 60)
print("")
print(template)
PYEOF
    ;;

  compare)
    python3 << 'PYEOF'
chains = [
    {
        "name": "Solana",
        "deploy_cost": "$2-5",
        "speed": "400ms",
        "dex": "Raydium/Pump.fun",
        "pros": "Cheap, fast, Pump.fun easy launch",
        "cons": "SPL token complexity, different tooling",
        "best_for": "Meme tokens, fast launches"
    },
    {
        "name": "Ethereum",
        "deploy_cost": "$50-500",
        "speed": "12s",
        "dex": "Uniswap V3",
        "pros": "Largest ecosystem, most trusted",
        "cons": "Expensive gas, slow",
        "best_for": "Serious projects, DeFi tokens"
    },
    {
        "name": "Base",
        "deploy_cost": "$1-3",
        "speed": "2s",
        "dex": "Aerodrome",
        "pros": "Cheap, Coinbase backing, growing fast",
        "cons": "Smaller ecosystem than ETH L1",
        "best_for": "Cost-effective EVM launches"
    },
    {
        "name": "BSC",
        "deploy_cost": "$3-10",
        "speed": "3s",
        "dex": "PancakeSwap",
        "pros": "Cheap, large Asian community",
        "cons": "Scam reputation, centralized",
        "best_for": "Asian market tokens"
    },
    {
        "name": "Arbitrum",
        "deploy_cost": "$1-5",
        "speed": "~1s",
        "dex": "Camelot/Uniswap",
        "pros": "Fast, cheap, strong DeFi",
        "cons": "Sequencer centralization",
        "best_for": "DeFi-focused tokens"
    }
]

print("=" * 70)
print("CHAIN COMPARISON FOR TOKEN LAUNCH")
print("=" * 70)
print("")
header = "{:<12} {:<12} {:<8} {:<20} {:<25}".format("Chain", "Cost", "Speed", "DEX", "Best For")
print(header)
print("-" * 70)
for c in chains:
    print("{:<12} {:<12} {:<8} {:<20} {:<25}".format(
        c["name"], c["deploy_cost"], c["speed"], c["dex"], c["best_for"]))

print("")
for c in chains:
    print("{}:".format(c["name"]))
    print("  ✅ {}".format(c["pros"]))
    print("  ❌ {}".format(c["cons"]))
    print("")
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
Token Launcher — Create and deploy tokens on multiple chains

COMMANDS:
  create <name> <symbol> <supply> [chain] [decimals] [buy_tax] [sell_tax]
         Generate token configuration and launch guide

  check <contract_address> [chain]
         Security check for existing token contract

  liquidity <token> <amount_usd> [chain]
         Liquidity provision guide with IL calculator

  audit
         Complete token launch audit checklist

  template [chain]
         Get contract template for chain (solana|ethereum|base|bsc)

  compare
         Compare chains for token deployment

EXAMPLES:
  bash token.sh create MyMeme MEME 1000000000 solana
  bash token.sh check 0x1234...abcd ethereum
  bash token.sh liquidity MEME 5000 solana
  bash token.sh audit
  bash token.sh template ethereum
  bash token.sh compare

SUPPORTED CHAINS: solana, ethereum, base, bsc, arbitrum
HELPEOF
    ;;
esac

echo ""
echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
