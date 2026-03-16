#!/usr/bin/env bash
# Shopify Helper — Shopify建站助手
# Usage: bash shopify.sh <command> [args...]

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

case "$CMD" in

setup)
cat <<'PROMPT'
## 🏪 Shopify店铺搭建

### 建站流程

**Step 1: 注册和基础设置**
1. 注册Shopify账号 (shopify.com)
2. 选择套餐

| 套餐 | 月费 | 交易费 | 适合 |
|------|------|--------|------|
| Basic | $39/月 | 2.9%+30¢ | 新手/小店 |
| Shopify | $105/月 | 2.6%+30¢ | 成长期 |
| Advanced | $399/月 | 2.4%+30¢ | 规模化 |
| Plus | $2300/月 | 定制 | 大品牌 |

**Step 2: 店铺基本信息**
- [ ] 店铺名称
- [ ] 品牌Logo (推荐尺寸: 250×250px)
- [ ] 品牌色彩 (主色+辅色+强调色)
- [ ] 联系邮箱
- [ ] 联系电话
- [ ] 公司地址

**Step 3: 域名设置**
```
选项A: 购买新域名 (通过Shopify或GoDaddy)
选项B: 连接已有域名

域名建议:
- 简短好记
- 与品牌一致
- .com优先
- 避免连字符和数字
```

**Step 4: 支付设置**
| 支付方式 | 覆盖 | 费率 |
|----------|------|------|
| Shopify Payments | 20+国家 | 最低 |
| PayPal | 全球 | 2.9%+30¢ |
| Stripe | 40+国家 | 2.9%+30¢ |
| 支付宝/微信 | 中国 | 需集成 |

**Step 5: 物流设置**
- 配送区域和费率
- 发货地址
- 包装重量预设
- 免费配送规则

**Step 6: 税务设置**
- 美国各州销售税 (自动计算)
- 欧盟VAT
- 其他国家税务

**Step 7: 法律页面**
- [ ] Privacy Policy (隐私政策)
- [ ] Terms of Service (服务条款)
- [ ] Refund Policy (退款政策)
- [ ] Shipping Policy (配送政策)

💡 Shopify可自动生成法律页面模板
PROMPT
echo ""
echo "📌 输入信息: ${INPUT:-请提供店铺类型和需求}"
;;

theme)
cat <<'PROMPT'
## 🎨 Shopify主题定制

### 免费主题推荐
| 主题 | 风格 | 适合品类 | 特点 |
|------|------|----------|------|
| Dawn | 简约现代 | 通用 | 官方默认，性能最佳 |
| Craft | 手工艺 | 手工/艺术 | 故事感强 |
| Crave | 餐饮 | 食品/饮品 | 美食风格 |
| Sense | 美妆 | 美妆/护肤 | 精致优雅 |
| Ride | 运动 | 运动/户外 | 活力动感 |
| Refresh | 健康 | 保健/养生 | 清新自然 |

### 付费主题推荐
| 主题 | 价格 | 适合 | 特点 |
|------|------|------|------|
| Prestige | $350 | 高端品牌 | 奢华感 |
| Impact | $350 | 潮牌 | 视觉冲击 |
| Symmetry | $350 | 通用 | 均衡布局 |
| Impulse | $350 | 时尚 | 画册感 |

### 主题定制要点

**1. 首页结构**
```
Header (导航+Logo+购物车)
  ↓
Hero Banner (大图+CTA)
  ↓
Featured Collection (精选系列)
  ↓
About/Story (品牌故事)
  ↓
Testimonials (客户评价)
  ↓
Newsletter (邮件订阅)
  ↓
Footer (链接+社交媒体)
```

**2. 色彩系统**
| 用途 | 建议 |
|------|------|
| 主色 | 品牌色，用于Logo/按钮 |
| 背景色 | 白色或浅灰 |
| 文字色 | 深灰(#333) |
| CTA按钮 | 对比色，醒目 |
| 链接色 | 与品牌色一致 |

**3. 字体选择**
| 用途 | 推荐 |
|------|------|
| 标题 | Playfair Display / Montserrat |
| 正文 | Open Sans / Lato / Roboto |
| 中文 | Noto Sans SC / 思源黑体 |

**4. 图片规范**
| 位置 | 推荐尺寸 | 格式 |
|------|----------|------|
| Hero Banner | 1920×800px | JPG/WebP |
| 产品图 | 2048×2048px | PNG(白底) |
| Collection | 1024×1024px | JPG |
| Blog | 1200×628px | JPG |
| Logo | 250×250px | PNG(透明) |
| Favicon | 32×32px | ICO/PNG |

### 移动端优化
- 按钮大小≥44px (手指可触)
- 文字≥16px (不用放大)
- 图片压缩 (TinyPNG)
- 汉堡菜单简洁
- 底部固定购买栏
PROMPT
echo ""
echo "📌 输入信息: ${INPUT:-请提供品牌风格和偏好}"
;;

product)
cat <<'PROMPT'
## 📦 产品管理

### 产品上架清单

**1. 基本信息**
- [ ] 产品标题 (SEO友好)
- [ ] 产品描述 (HTML/Rich Text)
- [ ] 产品类型 (Product Type)
- [ ] 供应商 (Vendor)
- [ ] 标签 (Tags)
- [ ] 系列 (Collections)

**2. 产品图片**
| 要求 | 标准 |
|------|------|
| 数量 | 5-8张 |
| 主图 | 白底/正面 |
| 尺寸 | 2048×2048px |
| 格式 | JPG/PNG/WebP |
| 大小 | <5MB |
| 内容 | 正面/侧面/细节/场景/尺寸对比 |

**3. 价格设置**
| 字段 | 说明 |
|------|------|
| Price | 售价 |
| Compare at price | 原价(划线价) |
| Cost per item | 成本(不显示) |
| 利润率 | 自动计算 |

**4. 库存管理**
- SKU编码规则: [品类]-[款式]-[颜色]-[尺码]
- 示例: TS-V1-BLK-L (T恤-V1款-黑色-L码)
- 跟踪库存数量
- 低库存提醒

**5. 变体设置 (Variants)**
```
尺寸: S / M / L / XL / XXL
颜色: 黑色 / 白色 / 蓝色
材质: 纯棉 / 混纺

每个变体可设置:
- 独立价格
- 独立库存
- 独立SKU
- 独立图片
```

**6. 产品描述模板**
```html
<h3>产品特点</h3>
<ul>
  <li>✅ 卖点1 — 详细描述</li>
  <li>✅ 卖点2 — 详细描述</li>
  <li>✅ 卖点3 — 详细描述</li>
</ul>

<h3>产品规格</h3>
<table>
  <tr><td>材质</td><td>XXX</td></tr>
  <tr><td>尺寸</td><td>XXX</td></tr>
  <tr><td>重量</td><td>XXX</td></tr>
</table>

<h3>使用场景</h3>
<p>场景描述...</p>

<h3>包装清单</h3>
<ul>
  <li>产品 × 1</li>
  <li>说明书 × 1</li>
</ul>
```

### 批量管理
- 使用CSV批量导入
- Shopify Matrixify APP
- 批量编辑价格/库存
PROMPT
echo ""
echo "📌 输入信息: ${INPUT:-请提供产品信息以创建listing}"
;;

seo)
cat <<'PROMPT'
## 🔍 Shopify SEO优化

### 核心SEO设置

**1. 页面SEO**
| 页面 | Title格式 | Meta Description |
|------|-----------|-----------------|
| 首页 | 品牌名 - 核心定位 | 50-160字符描述 |
| 产品页 | 产品名 - 品牌 | 产品卖点摘要 |
| 系列页 | 系列名 - 品牌 | 系列描述 |
| 博客页 | 文章标题 - 品牌 | 文章摘要 |

**2. URL结构**
```
✅ 好的URL:
/products/wireless-bluetooth-earbuds
/collections/summer-dresses
/blogs/style-guide/how-to-wear-linen

❌ 差的URL:
/products/product-1234
/collections/all
```

**3. 图片SEO**
- 文件名: wireless-earbuds-black.jpg (非IMG_1234.jpg)
- Alt标签: "Brand wireless Bluetooth earbuds in black with charging case"
- 压缩: <500KB (使用TinyPNG)
- 格式: WebP优先

**4. 网站速度**
| 优化项 | 方法 |
|--------|------|
| 图片优化 | WebP格式+压缩 |
| APP精简 | 只保留必要APP |
| 代码优化 | 移除不用的JS/CSS |
| CDN | Shopify自带CDN |
| 懒加载 | 图片延迟加载 |
| 目标 | PageSpeed分数>80 |

**5. 内容营销 (博客)**
```
建站初期发布10-20篇高质量博客:
- 产品使用指南
- 行业知识科普
- 穿搭/搭配建议
- 常见问题解答
- 品牌故事

每篇1000-2000词
包含内部链接到产品页
```

**6. 结构化数据**
```json
{
  "@type": "Product",
  "name": "产品名",
  "image": "图片URL",
  "description": "描述",
  "offers": {
    "price": "价格",
    "availability": "InStock"
  },
  "aggregateRating": {
    "ratingValue": "4.5",
    "reviewCount": "120"
  }
}
```

### SEO检查工具
| 工具 | 用途 | 价格 |
|------|------|------|
| Google Search Console | 搜索表现 | 免费 |
| Google Analytics | 流量分析 | 免费 |
| Ahrefs | 外链分析 | $99+/月 |
| SEMrush | 关键词研究 | $129+/月 |
| Plug in SEO (APP) | 站内SEO检查 | 免费版有 |

### 技术SEO清单
- [ ] sitemap.xml (Shopify自动生成)
- [ ] robots.txt (Shopify自动管理)
- [ ] SSL证书 (Shopify自带)
- [ ] 301重定向 (URL变更时)
- [ ] 规范化标签 (canonical)
- [ ] 移动端适配 (响应式)
- [ ] 页面速度优化
- [ ] 结构化数据标记
PROMPT
echo ""
echo "📌 输入信息: ${INPUT:-请提供SEO优化需求}"
;;

app)
cat <<'PROMPT'
## 📱 Shopify APP推荐

### 必装APP (基础功能)
| APP名称 | 功能 | 价格 | 优先级 |
|---------|------|------|--------|
| Judge.me | 产品评价 | 免费起 | ★★★★★ |
| Klaviyo | 邮件营销 | 免费起 | ★★★★★ |
| Google Channel | Google购物广告 | 免费 | ★★★★★ |
| Facebook Channel | FB/IG广告 | 免费 | ★★★★★ |
| Shopify Inbox | 在线客服 | 免费 | ★★★★ |
| DSers | AliExpress代发 | 免费起 | ★★★★(代发) |

### 营销增长
| APP名称 | 功能 | 价格 |
|---------|------|------|
| Privy | 弹窗/优惠券 | 免费起 |
| Smile.io | 会员积分 | 免费起 |
| ReferralCandy | 推荐返利 | $49/月 |
| Omnisend | 全渠道营销 | 免费起 |
| SMSBump | 短信营销 | 免费起 |

### 转化优化
| APP名称 | 功能 | 价格 |
|---------|------|------|
| Shogun | 页面编辑器 | $39/月 |
| ReConvert | 感谢页优化 | 免费起 |
| Frequently Bought | 关联推荐 | 免费起 |
| Loox | 图片评价 | $9.99/月 |
| Tidio | AI客服 | 免费起 |

### SEO工具
| APP名称 | 功能 | 价格 |
|---------|------|------|
| Plug in SEO | SEO检查 | 免费起 |
| JSON-LD for SEO | 结构化数据 | $9.99/月 |
| Smart SEO | 自动Meta/Alt | 免费起 |

### 运营管理
| APP名称 | 功能 | 价格 |
|---------|------|------|
| Matrixify | 批量导入导出 | 免费起 |
| Inventory Planner | 库存预测 | $99/月 |
| ShipStation | 物流管理 | $9.99/月 |
| QuickBooks | 财务对接 | 集成 |

### APP安装建议
```
⚠️ 注意事项:
1. 不要安装超过15-20个APP
2. 每安装一个APP测试网站速度
3. 卸载不用的APP（残留代码手动清理）
4. 优先选择评分4.5+的APP
5. 先用免费版本测试
6. 定期审查APP必要性
```
PROMPT
echo ""
echo "📌 输入信息: ${INPUT:-请提供店铺类型以推荐APP}"
;;

launch)
cat <<'PROMPT'
## 🚀 上线前检查清单

### 一、基础设置
- [ ] 域名已连接并正常访问
- [ ] SSL证书已启用 (HTTPS)
- [ ] Favicon已设置
- [ ] 店铺名称正确
- [ ] 联系信息完整
- [ ] 时区和货币正确

### 二、页面检查
- [ ] 首页加载正常
- [ ] 导航菜单完整
- [ ] 产品页面正常
- [ ] 购物车功能正常
- [ ] 结账流程顺畅
- [ ] 404页面已定制
- [ ] 法律页面已创建
  - [ ] Privacy Policy
  - [ ] Terms of Service
  - [ ] Refund Policy
  - [ ] Shipping Policy

### 三、产品检查
- [ ] 所有产品已上架
- [ ] 产品图片高清
- [ ] 产品描述完整
- [ ] 价格正确
- [ ] 库存数量准确
- [ ] 变体设置正确
- [ ] 产品系列分类正确

### 四、支付和物流
- [ ] 支付方式已测试
- [ ] 测试订单已完成
- [ ] 物流费率已设置
- [ ] 税务设置正确
- [ ] 退款政策清晰
- [ ] 订单确认邮件正常

### 五、SEO和营销
- [ ] 页面Title和Description已优化
- [ ] 图片Alt标签已添加
- [ ] Google Analytics已安装
- [ ] Facebook Pixel已安装
- [ ] Google Search Console已验证
- [ ] 社交媒体链接正确
- [ ] 邮件订阅功能正常

### 六、移动端
- [ ] 手机端显示正常
- [ ] 触控元素可点击
- [ ] 图片加载快速
- [ ] 结账流程手机友好
- [ ] 底部导航正常

### 七、速度和安全
- [ ] PageSpeed分数>80
- [ ] 图片已压缩
- [ ] 不必要的APP已卸载
- [ ] GDPR合规 (Cookie提示)
- [ ] 管理员二次验证开启

### 八、上线后待办
- [ ] 密码保护已移除
- [ ] 发布到Google Search Console
- [ ] 提交sitemap
- [ ] 发布社交媒体公告
- [ ] 开启广告投放
- [ ] 设置库存提醒
- [ ] 安排第一批推广活动

### 上线时间建议
| 建议 | 原因 |
|------|------|
| 周二-周四上线 | 避免周末客服不在 |
| 上午10点 | 有时间处理问题 |
| 非节假日 | 减少物流延迟 |
| 预留一周测试 | 发现并修复问题 |
PROMPT
echo ""
echo "📌 输入信息: ${INPUT:-请提供店铺状态以定制检查清单}"
;;

help|*)
cat <<'EOF'
Shopify Helper — Shopify建站助手

Usage: bash shopify.sh <command> [args...]

Commands:
  setup       店铺搭建 — 基础设置和配置
  theme       主题定制 — 主题选择和定制
  product     产品管理 — 产品上架和管理
  seo         SEO优化 — 搜索引擎优化
  app         应用推荐 — 必备和好用的APP
  launch      上线检查 — Launch Checklist

Examples:
  bash shopify.sh setup "服装品牌独立站"
  bash shopify.sh theme "简约风格"
  bash shopify.sh product "产品上架流程"
  bash shopify.sh seo "独立站SEO"
  bash shopify.sh app "必装应用"
  bash shopify.sh launch "上线前检查"

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
;;

esac
