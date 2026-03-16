# Crypto News Feed — Tips & Tricks 📰

## Filtering Strategy

1. **Start broad, then narrow** — Fetch all news first, then apply keyword filters to find what matters.
2. **Use category filters** — Built-in categories (DeFi, NFT, L2, Regulation, Meme) save you from writing keyword lists.
3. **Combine sentiment + keywords** — "Show me bearish Ethereum news" is more useful than either filter alone.

## Sentiment Analysis Notes

- Sentiment scores are **lexicon-based**, not ML — they catch obvious tone but can miss sarcasm
- Headlines are often more sensational than article content — scores reflect headline sentiment
- A sudden shift from neutral to very bearish across multiple sources is a stronger signal than one bearish article
- Use sentiment trends over time, not single-article scores

## Daily Digest Tips

- Set up a cron job for 8am digest — start your day with a market sentiment overview
- Share digests with your team via the HTML report — it's self-contained, no server needed
- Compare today's sentiment to yesterday's — the delta matters more than the absolute score

## Source Management

- Add niche sources (project blogs, researcher substacks) for alpha
- Remove sources that are too promotional or low-quality
- Mix institutional sources (CoinDesk, The Block) with crypto-native ones (Bankless, DeFi Pulse)
- Check source reliability quarterly — some blogs go inactive or change quality

## Common Patterns to Watch

- 📈 Multiple sources bullish on same topic = momentum building
- 📉 Sudden bearish shift across all sources = potential black swan
- 🔄 Narrative shifting (e.g., "ETH killer" → "ETH scaling") = market sentiment change
- 🆕 New topic appearing across sources = emerging trend worth investigating
