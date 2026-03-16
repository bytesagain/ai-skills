# Tips — Shopify Toolkit

> Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

## Quick Start

1. Go to your Shopify Admin → Settings → Apps and sales channels
2. Click "Develop apps" (enable custom app development if prompted)
3. Create a new app and configure Admin API scopes:
   - `read_products`, `write_products`
   - `read_orders`, `write_orders`
   - `read_customers`, `write_customers`
   - `read_inventory`, `write_inventory`
   - `read_locations`
4. Install the app and copy the Admin API access token (`shpat_...`)
5. Set `SHOPIFY_STORE=yourstore` and `SHOPIFY_ACCESS_TOKEN=shpat_xxx`

## Access Token Format

- Starts with `shpat_` (Shopify Private Access Token)
- The token is shown only once when you install the app — save it securely!
- If lost, uninstall and reinstall the app to generate a new token

## Product Variants

When creating products with variants:
```json
[
  {"title": "Small", "price": "19.99", "sku": "TSHIRT-S", "inventory_quantity": 100},
  {"title": "Medium", "price": "19.99", "sku": "TSHIRT-M", "inventory_quantity": 150},
  {"title": "Large", "price": "21.99", "sku": "TSHIRT-L", "inventory_quantity": 75}
]
```

## Order Statuses

- `open` — Unfulfilled, requires action
- `closed` — Fulfilled and completed
- `cancelled` — Order was cancelled
- `any` — All orders regardless of status

## Inventory Management

- Each variant has an `inventory_item_id` — use this for inventory operations
- Each store has one or more `location_id`s — use `locations` to find them
- `inventory set` sets absolute quantity
- `inventory adjust` adds/subtracts from current quantity (use negative numbers to decrease)

## API Versions

Shopify uses date-based API versions:
- Default: `2024-01`
- Stable versions are supported for ~12 months
- Set `SHOPIFY_API_VERSION=2024-04` to use a different version

## Rate Limits

- Shopify uses a leaky bucket algorithm
- 40 requests per app per store (bucket fills at 2/second)
- The script handles rate limiting with automatic retries

## Troubleshooting

- **401 Unauthorized**: Access token is invalid or app was uninstalled
- **403 Forbidden**: App doesn't have the required API scope
- **404 Not Found**: Resource ID is wrong or resource was deleted
- **422 Unprocessable Entity**: Invalid data format in create/update requests
- **429 Too Many Requests**: Rate limited — script auto-retries

## Pro Tips

- Use `summary` for a quick daily store overview
- Search products before creating to avoid duplicates
- Use `inventory adjust` for stock movements (safer than `set`)
- Export orders in `json` format for financial reporting
- Check `locations` first before managing inventory
