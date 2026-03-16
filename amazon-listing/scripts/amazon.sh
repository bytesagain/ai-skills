#!/usr/bin/env bash
# Amazon Listing — 亚马逊Listing优化
# Usage: bash amazon.sh <command> [args...]

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

case "$CMD" in

title)
cat <<'PROMPT'
## 🏷️ 亚马逊标题优化

### 标题公式
```
[Brand] [Core Keyword] [Key Feature 1] [Key Feature 2] [Use Case/Target] [Size/Color/Variant]
```

### 标题规则
| 规则 | 要求 |
|------|------|
| 字符限制 | 200字符 (手机显示约80字符) |
| 首字母 | 每个词首字母大写 (介词/冠词除外) |
| 禁止 | 促销语、HTML、特殊符号、主观形容 |
| 品牌 | 必须在开头 |
| 关键词 | 核心词靠前放 |

### 标题优化示例
```
❌ Before:
"Best Wireless Earbuds!!! Amazing Sound Quality, Buy Now, Free Shipping"

✅ After:
"BrandX Wireless Earbuds Bluetooth 5.3, Active Noise Cancelling, 
32H Battery Life, IPX5 Waterproof, in-Ear Headphones for Running (Black)"
```

### 标题结构模板

**电子产品**
> Brand + Product Type + Key Tech Spec + Feature 1 + Feature 2 + Compatible/For + (Color)

**家居用品**
> Brand + Product Type + Material + Size + Feature + Use Case + (Pack Count)

**服装**
> Brand + Product Type + [Gender] + Feature + Material + Occasion + (Size)

**美妆**
> Brand + Product Type + Key Ingredient + Skin Type + Benefit + Size

### 标题关键词研究工具
| 工具 | 用途 | 价格 |
|------|------|------|
| Helium10 | 关键词研究+竞品分析 | $39-249/月 |
| Jungle Scout | 选品+关键词 | $49-129/月 |
| Merchant Words | 搜索词数据 | $35-149/月 |
| 亚马逊搜索建议 | 免费关键词 | 免费 |
| Brand Analytics | 品牌分析 | 免费(品牌卖家) |

### 标题评分检查
- [ ] 核心关键词在前80字符内
- [ ] 包含品牌名
- [ ] 无禁止词汇
- [ ] 首字母大写规范
- [ ] 200字符以内
- [ ] 涵盖3-5个关键词
- [ ] 可读性好 (不是关键词堆砌)
PROMPT
echo ""
echo "📌 输入信息: ${INPUT:-请提供产品信息以优化标题}"
;;

bullet)
cat <<'PROMPT'
## 📝 五点描述 (Bullet Points)

### Bullet Points规则
| 规则 | 要求 |
|------|------|
| 数量 | 5条 (标准) |
| 字符 | 每条≤200字符 (建议150以内) |
| 格式 | 大写开头关键词 + 详细描述 |
| 内容 | 卖点/功能/好处/规格 |

### 五条Bullet标准结构

**Bullet 1: 核心卖点 (USP)**
> 【UNIQUE SELLING POINT】— 最大的差异化优势
> "ACTIVE NOISE CANCELLING - Block out 95% of background noise..."

**Bullet 2: 技术/品质**
> 【TECHNOLOGY/QUALITY】— 技术细节和品质保证
> "BLUETOOTH 5.3 TECHNOLOGY - Stable connection up to 33ft..."

**Bullet 3: 便捷/体验**
> 【CONVENIENCE/EXPERIENCE】— 使用体验优势
> "32-HOUR BATTERY LIFE - 8 hours on single charge..."

**Bullet 4: 设计/适用**
> 【DESIGN/COMPATIBILITY】— 设计和适用场景
> "ERGONOMIC DESIGN - Lightweight 5g per earbud..."

**Bullet 5: 保障/售后**
> 【WARRANTY/SATISFACTION】— 品质保障
> "WHAT YOU GET - 1x Earbuds, 1x Charging Case, 3x Ear Tips..."

### 写作技巧
| 技巧 | 示例 |
|------|------|
| 数字化 | "32小时续航" > "超长续航" |
| 场景化 | "通勤、健身、办公多场景" |
| 对比化 | "比上一代轻40%" |
| 认证化 | "IPX5防水认证" |
| 解决痛点 | "告别缠线烦恼" |

### A+ Content (EBC) 要点
- 品牌故事模块
- 产品对比表
- 场景图+文字说明
- 技术参数可视化
- 提升转化率5-10%
PROMPT
echo ""
echo "📌 输入信息: ${INPUT:-请提供产品信息以生成Bullet Points}"
;;

backend)
cat <<'PROMPT'
## 🔑 后台关键词 (Search Terms)

### 规则
| 规则 | 要求 |
|------|------|
| 总字节数 | ≤249 bytes |
| 格式 | 空格分隔，不用逗号 |
| 不要重复 | 标题中已有的词不需要 |
| 小写 | 全部小写 |
| 无标点 | 不用逗号、引号等 |
| 无品牌词 | 不要用竞品品牌名 |

### 关键词收集方法
```
1. 亚马逊搜索建议 (免费)
   → 输入核心词，记录下拉建议

2. 竞品Listing分析
   → 分析Top 10竞品的标题和Bullet

3. 工具挖掘
   → Helium10 Cerebro (反查竞品关键词)
   → Helium10 Magnet (关键词拓展)

4. Brand Analytics
   → 品牌卖家免费使用搜索词报告
```

### Search Terms填写模板
```
Field 1 (Search Terms):
[同义词] [相关词] [使用场景词] [属性词] [西班牙语等]

示例:
earphone headset earpiece tws true wireless
running workout gym sport exercise fitness
noise reduction anc ambient sound
charging case portable long battery
gift present holiday christmas birthday
```

### 关键词优化清单
- [ ] 收集100+相关关键词
- [ ] 去除标题中已有的词
- [ ] 去除重复和无关词
- [ ] 按搜索量排序
- [ ] 控制在249字节内
- [ ] 包含拼写变体
- [ ] 包含西班牙语常见词 (美国站)
- [ ] 定期更新 (季节/趋势变化)

### 关键词分类
| 类别 | 示例 | 优先级 |
|------|------|--------|
| 同义词 | earphone/headset/earpiece | 高 |
| 使用场景 | running/office/commute | 高 |
| 属性词 | lightweight/compact/portable | 中 |
| 人群词 | men/women/kids/seniors | 中 |
| 节日词 | gift/christmas/valentine | 季节性 |
| 外语词 | audifonos/auriculares | 低-中 |
PROMPT
echo ""
echo "📌 输入信息: ${INPUT:-请提供产品和现有关键词}"
;;

ppc)
cat <<'PROMPT'
## 💰 PPC广告策略

### 广告类型
| 类型 | 说明 | 适用 |
|------|------|------|
| SP (Sponsored Products) | 商品推广 | 最常用 |
| SB (Sponsored Brands) | 品牌推广 | 品牌卖家 |
| SD (Sponsored Display) | 展示推广 | 再营销 |
| SBV (Sponsored Brand Video) | 视频广告 | 高转化 |

### PPC投放流程
```
Phase 1: 自动广告 (2-4周)
  → 低预算($10-20/天)
  → 收集搜索词数据
  → 发现有效关键词

Phase 2: 手动广告 (持续优化)
  → 广泛匹配: 拓展关键词
  → 词组匹配: 精准一些
  → 精准匹配: 最精准+出价高

Phase 3: 否定关键词
  → 从搜索词报告找出无效词
  → 添加否定精准/否定词组
```

### ACOS优化
```
ACOS = 广告花费 / 广告销售额 × 100%

目标ACOS参考:
  < 15%: 优秀 (盈利)
  15-25%: 良好
  25-35%: 一般
  > 35%: 需要优化

Break-even ACOS = 利润率
  如利润率30%，ACOS<30%即不亏
```

### 竞价策略
| 关键词类型 | 出价策略 | 匹配方式 |
|-----------|----------|----------|
| 品牌词 | 高出价 | 精准 |
| 核心词(高转化) | 中高出价 | 精准+词组 |
| 长尾词 | 低出价 | 广泛+词组 |
| 竞品词 | 中出价 | 精准 |

### 广告优化检查 (每周)
- [ ] 检查搜索词报告
- [ ] 添加否定关键词
- [ ] 调整出价 (降ACOS高的/加ACOS低的)
- [ ] 暂停无转化广告
- [ ] 优化预算分配
- [ ] 测试新关键词

### 预算分配建议
| 广告类型 | 预算占比 |
|----------|----------|
| SP精准匹配 | 40% |
| SP广泛/词组 | 25% |
| SP自动 | 15% |
| SB品牌推广 | 10% |
| SD展示推广 | 10% |
PROMPT
echo ""
echo "📌 输入信息: ${INPUT:-请提供广告需求或优化问题}"
;;

review)
cat <<'PROMPT'
## ⭐ 评价管理

### 合规获评方式
| 方式 | 说明 | 效果 |
|------|------|------|
| 亚马逊Vine | 官方评测计划 | ★★★★★ |
| Request a Review | 后台一键请评 | ★★★ |
| 产品插页 | 包装内放卡片 | ★★★ |
| 邮件跟进 | Buyer-Seller Message | ★★ |
| 优质产品 | 好产品自然好评 | ★★★★★ |

### Vine计划
```
费用: $200/ASIN (30个评价)
适合: 新品上架
注意:
  - Vine评论者比较严格
  - 确保产品质量过关
  - 一旦加入不可取消
```

### 产品插页模板 (合规版)
```
Thank You for Your Purchase! 🎉

We hope you love your [product].

✅ Your satisfaction is our priority
✅ Need help? Contact us: support@brand.com

We'd love to hear your feedback!
Scan the QR code to share your experience.

⚠️ 禁止: 不能写"留好评"、不能提供激励
```

### 差评处理流程
```
1. 分析差评原因
   ├── 产品问题 → 改进产品
   ├── 物流问题 → 联系亚马逊
   ├── 使用误解 → 优化说明
   └── 恶意差评 → 举报

2. 公开回复 (品牌注册后)
   → 道歉+解决方案
   → 专业、友善

3. 联系买家 (通过订单)
   → 提供解决方案
   → 不要直接要求删评

4. 违规评价举报
   → 与产品无关
   → 包含不当内容
   → 竞品恶意评价
```

### 评价数据监控
| 指标 | 健康标准 |
|------|----------|
| 评分 | ≥4.0 |
| 评价数 | 竞品平均以上 |
| 近期趋势 | 好评增长 |
| 差评率 | <10% |
| 1-2星占比 | <5% |
PROMPT
echo ""
echo "📌 输入信息: ${INPUT:-请提供评价相关需求}"
;;

rank)
cat <<'PROMPT'
## 📈 排名提升策略

### BSR (Best Sellers Rank) 影响因素
| 因素 | 权重 | 说明 |
|------|------|------|
| 销量/销售速度 | ★★★★★ | 最核心因素 |
| 转化率 | ★★★★ | 点击→购买的比例 |
| 关键词相关性 | ★★★★ | Listing关键词匹配 |
| 评价数量和质量 | ★★★ | 社会证明 |
| 价格竞争力 | ★★★ | 影响转化 |
| 库存可用性 | ★★ | 断货影响排名 |
| 图片质量 | ★★★ | 影响点击率 |
| A+ Content | ★★ | 提升转化率 |

### 关键词排名优化
```
提升路径:
1. 优化Listing (标题/Bullet/后台词)
   → 确保关键词覆盖
   
2. PPC推广目标关键词
   → 精准匹配+高出价
   → 抢占关键词前3位
   
3. 提升转化率
   → 优化主图 (CTR)
   → 优化价格 (竞争力)
   → 增加评价 (信任)
   
4. 促销冲量
   → Coupon优惠券
   → Lightning Deal秒杀
   → 站外deal
```

### 新品推广时间表
| 周次 | 动作 | 目标 |
|------|------|------|
| W1-2 | 开自动广告+Vine | 收集数据 |
| W3-4 | 开手动广告+优惠券 | 出单+评价 |
| W5-6 | 优化广告+A+页面 | 提升转化 |
| W7-8 | 冲销量 (秒杀/站外) | 冲BSR |
| W9+ | 持续优化+利润 | 稳定排名 |

### 转化率优化清单
- [ ] 主图白底+高清+多角度 (7-9张)
- [ ] 视频展示产品使用
- [ ] 标题包含核心关键词
- [ ] Bullet Points突出卖点
- [ ] A+ Content品牌页面
- [ ] 价格有竞争力
- [ ] 评价4.0+，50+条
- [ ] Coupon/促销标识
- [ ] 库存充足不断货
- [ ] FBA (Prime标识)

### 竞品排名监控
| ASIN | 品牌 | BSR | 价格 | 评价数 | 评分 | 月销量 |
|------|------|-----|------|--------|------|--------|
| | | | $ | | | |
| | | | $ | | | |
| | | | $ | | | |
PROMPT
echo ""
echo "📌 输入信息: ${INPUT:-请提供产品ASIN或排名问题}"
;;

help|*)
cat <<'EOF'
Amazon Listing — 亚马逊Listing优化

Usage: bash amazon.sh <command> [args...]

Commands:
  title       标题优化 — 高转化标题撰写
  bullet      五点描述 — Bullet Points优化
  backend     后台关键词 — Search Terms设置
  ppc         PPC广告 — 广告策略和优化
  review      评价管理 — 获评和差评处理
  rank        排名提升 — BSR和关键词排名

Examples:
  bash amazon.sh title "wireless earbuds"
  bash amazon.sh bullet "noise cancelling headphones"
  bash amazon.sh backend "关键词优化"
  bash amazon.sh ppc "ACOS优化"
  bash amazon.sh review "获评策略"
  bash amazon.sh rank "提升BSR"

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
;;

esac
