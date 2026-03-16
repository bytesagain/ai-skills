#!/usr/bin/env bash
# product-listing-generator — e-commerce product copy generator
# Usage: product.sh <command> [args...]

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

show_help() {
cat <<'EOF'
╔══════════════════════════════════════════════════════╗
║       🛒  Product Listing Generator  🛒             ║
╚══════════════════════════════════════════════════════╝

Usage: product.sh <command> [arguments]

Commands:
  generate "产品名" [--platform taobao|pdd|amazon|shopify]
      Generate full listing (titles + selling points + description + SEO).
      Omit --platform to generate for ALL platforms.

  title "产品名"
      Generate 5 title variants.

  seo "产品名"
      Generate SEO keyword lists (core / long-tail / related).

  desc "产品名"
      Generate a complete product description.

  compare "产品A" "产品B"
      Generate competitive comparison copy.

  cross-border "产品名" "目标市场"
      跨境电商文案（亚马逊/Shopee/速卖通三平台）。
      含 bullet points、A+ 内容框架、多语种建议。

  video-script "产品名"
      产品短视频脚本（完整分镜：画面+旁白+字幕+BGM）。
      适用于抖音/TikTok/Reels/YouTube Shorts。

  faq "产品名"
      生成 12 个真实高频 FAQ + 专业回答。
      适用于详情页、客服话术、产品手册。

  bundle "产品1,产品2[,产品3]"
      组合套装文案（搭配逻辑+价格策略+多平台标题）。

  optimize "现有标题"
      标题优化诊断 — 分析现有标题问题（关键词/顺序/字数/卖点），
      输出5个优化版标题 + 关键词布局建议。
      卖家痛点："曝光不够，不知道标题哪里有问题"。

  pain "产品类别"
      用户痛点挖掘 — 输出该品类TOP10用户痛点和关注点，
      每个痛点对应文案切入角度 + 差评避雷清单。
      卖家痛点："不知道买家在意什么，文案没有说服力"。

  help
      Show this help message.

Examples:
  product.sh generate "蓝牙耳机" --platform taobao
  product.sh title "便携榨汁杯"
  product.sh seo "智能手表"
  product.sh desc "折叠键盘"
  product.sh compare "AirPods Pro" "华为FreeBuds Pro"
  product.sh cross-border "蓝牙音箱" "东南亚"
  product.sh video-script "筋膜枪"
  product.sh faq "空气炸锅"
  product.sh bundle "手机壳,钢化膜,充电线"
  product.sh optimize "蓝牙耳机 无线 运动"
  product.sh pain "蓝牙耳机"
EOF
}

run_python() {
python3 - "$@" <<'PYTHON_SCRIPT'
# -*- coding: utf-8 -*-
from __future__ import print_function
import sys
import textwrap
import datetime

# ──────────────────────────────────────────────
# Helpers
# ──────────────────────────────────────────────

def sep(title=""):
    line = "=" * 60
    if title:
        return "\n{line}\n  {title}\n{line}".format(line=line, title=title)
    return "\n" + line

def sub_sep(title=""):
    line = "-" * 50
    if title:
        return "\n{line}\n  {title}\n{line}".format(line=line, title=title)
    return "\n" + line

def today():
    return datetime.date.today().strftime("%Y-%m-%d")

# ──────────────────────────────────────────────
# Title generation
# ──────────────────────────────────────────────

def gen_titles(product):
    titles = [
        "【热销爆款】{p} 新款上市 品质保障 厂家直销 限时特惠".format(p=product),
        "{p} 旗舰款 高品质 多功能 送礼自用两相宜".format(p=product),
        "2024新款 {p} 高性价比 好评如潮 买到就是赚到".format(p=product),
        "{p} 正品保障 顺丰包邮 7天无理由退换 售后无忧".format(p=product),
        "【工厂直发】{p} 批发价零售 库存有限 先到先得".format(p=product),
    ]
    return titles

def cmd_title(product):
    print(sep("🏷️  标题生成 — {p}".format(p=product)))
    titles = gen_titles(product)
    for i, t in enumerate(titles, 1):
        print("\n  变体 {i}: {t}".format(i=i, t=t))
    print("")

# ──────────────────────────────────────────────
# SEO keywords
# ──────────────────────────────────────────────

def gen_seo(product):
    core = [product, "{p} 正品".format(p=product), "{p} 品牌".format(p=product)]
    longtail = [
        "{p} 哪个好".format(p=product),
        "{p} 怎么选".format(p=product),
        "{p} 推荐 2024".format(p=product),
        "{p} 性价比高".format(p=product),
        "{p} 评测对比".format(p=product),
    ]
    related = [
        "{p} 配件".format(p=product),
        "{p} 收纳".format(p=product),
        "{p} 替换装".format(p=product),
        "{p} 同款".format(p=product),
    ]
    return core, longtail, related

def cmd_seo(product):
    core, longtail, related = gen_seo(product)
    print(sep("🔍  SEO 关键词 — {p}".format(p=product)))
    print(sub_sep("核心关键词"))
    for kw in core:
        print("  • " + kw)
    print(sub_sep("长尾关键词"))
    for kw in longtail:
        print("  • " + kw)
    print(sub_sep("相关关键词"))
    for kw in related:
        print("  • " + kw)
    print("")

# ──────────────────────────────────────────────
# Description
# ──────────────────────────────────────────────

def gen_selling_points(product):
    return [
        "🌟 品质保障 — 精选优质材料，严格质检，每一件 {p} 都经过层层把关".format(p=product),
        "🚀 功能强大 — {p} 集多种实用功能于一体，满足您的多场景需求".format(p=product),
        "💰 超高性价比 — 同品质 {p} 中价格更优，工厂直销省去中间环节".format(p=product),
        "📦 极速发货 — 下单即发，顺丰/京东物流，最快次日达".format(p=product),
        "🛡️ 售后无忧 — 7天无理由退换，1年质保，专属客服一对一服务".format(p=product),
    ]

def cmd_desc(product):
    print(sep("📝  产品描述 — {p}".format(p=product)))

    print(sub_sep("产品简介"))
    intro = (
        "{p} 是一款专为追求品质生活的用户打造的产品。"
        "采用先进工艺和优质材料，兼顾实用性与美观度，"
        "无论是日常使用还是送礼，都是您的不二之选。"
    ).format(p=product)
    print(textwrap.fill(intro, width=60, initial_indent="  ", subsequent_indent="  "))

    print(sub_sep("核心卖点"))
    for sp in gen_selling_points(product):
        print("  " + sp)

    print(sub_sep("产品参数（示例）"))
    params = [
        ("产品名称", product),
        ("材质", "优质环保材料"),
        ("规格", "标准款 / 升级款 / 旗舰款"),
        ("颜色", "经典黑 / 简约白 / 时尚灰"),
        ("包装清单", "{p} x1、说明书 x1、保修卡 x1".format(p=product)),
    ]
    for k, v in params:
        print("  {k}: {v}".format(k=k, v=v))

    print(sub_sep("温馨提示"))
    print("  · 由于显示器色差，产品颜色以实物为准")
    print("  · 手动测量，尺寸存在1-3cm误差属正常现象")
    print("  · 收到商品如有问题请第一时间联系客服")
    print("")

# ──────────────────────────────────────────────
# Compare
# ──────────────────────────────────────────────

def cmd_compare(product_a, product_b):
    print(sep("⚔️  竞品对比 — {a} vs {b}".format(a=product_a, b=product_b)))

    dims = ["品质", "价格", "功能", "口碑", "售后"]
    print(sub_sep("对比维度"))
    header = "  {dim:<10} {a:<20} {b:<20}".format(dim="维度", a=product_a, b=product_b)
    print(header)
    print("  " + "-" * 50)

    comparisons = {
        "品质": ("精选材料,做工精细", "材料一般,中规中矩"),
        "价格": ("性价比高,直销价", "市场均价,偶有促销"),
        "功能": ("多功能集成", "基础功能为主"),
        "口碑": ("好评率98%+", "好评率90%+"),
        "售后": ("7天退换,1年保修", "15天退换,半年保修"),
    }
    for dim in dims:
        a_val, b_val = comparisons[dim]
        row = "  {dim:<10} {a:<20} {b:<20}".format(dim=dim, a=a_val, b=b_val)
        print(row)

    print(sub_sep("总结"))
    summary = (
        "综合对比，{a} 在品质、功能和售后方面更具优势，"
        "性价比更高；{b} 适合预算有限、需求基础的用户。"
        "建议根据个人需求和预算选择。"
    ).format(a=product_a, b=product_b)
    print(textwrap.fill(summary, width=60, initial_indent="  ", subsequent_indent="  "))
    print("")

# ──────────────────────────────────────────────
# Platform-specific generate
# ──────────────────────────────────────────────

PLATFORM_LABELS = {
    "taobao": "🟠 淘宝/天猫",
    "pdd": "🔴 拼多多",
    "amazon": "🟡 Amazon",
    "shopify": "🟢 独立站 (Shopify)",
}

def gen_platform_listing(product, platform):
    label = PLATFORM_LABELS.get(platform, platform)
    print(sub_sep("{label} — {p}".format(label=label, p=product)))

    if platform == "taobao":
        print("  📌 标题:")
        print("    【旗舰正品】{p} 2024新款 限时秒杀 顺丰包邮 🔥爆款热卖".format(p=product))
        print("")
        print("  📌 副标题:")
        print("    品质生活从这里开始！好评返现5元 收藏加购优先发货")
        print("")
        print("  📌 五大卖点:")
        points = [
            "✅ 正品保障，假一赔十",
            "✅ 顺丰包邮，极速达",
            "✅ 7天无理由退换",
            "✅ 厂家直销，省去中间差价",
            "✅ 月销10000+，好评如潮",
        ]
        for p_item in points:
            print("    " + p_item)
        print("")
        print("  📌 促销话术:")
        print("    🔥 限时特惠！前100名下单立减30元！")
        print("    💝 买二送一，多买多优惠！")

    elif platform == "pdd":
        print("  📌 标题:")
        print("    {p} 厂家直销 全网最低价 拼团更划算 包邮到家".format(p=product))
        print("")
        print("  📌 卖点（简洁直击）:")
        points = [
            "💰 工厂价直供，省掉中间商",
            "📦 48小时发货，全国包邮",
            "🔄 不满意包退，零风险购物",
        ]
        for p_item in points:
            print("    " + p_item)
        print("")
        print("  📌 拼团引导:")
        print("    👥 2人成团立减20元！分享给好友一起拼！")
        print("    ⏰ 限时拼团价，手慢无！")

    elif platform == "amazon":
        print("  📌 Title:")
        print("    {p} - Premium Quality | Multi-functional | Durable & Portable | Perfect Gift".format(p=product))
        print("")
        print("  📌 Bullet Points:")
        bullets = [
            "【Premium Material】Made with high-quality materials for long-lasting durability",
            "【Versatile Design】Suitable for multiple scenarios — home, office, travel",
            "【Easy to Use】Intuitive design, no complicated setup required",
            "【Perfect Gift】Elegant packaging, ideal for birthdays and holidays",
            "【Satisfaction Guaranteed】30-day money-back guarantee + 12-month warranty",
        ]
        for b in bullets:
            print("    • " + b)
        print("")
        print("  📌 Search Terms:")
        print("    {p}, {p} premium, best {p}, {p} gift, {p} portable".format(p=product))

    elif platform == "shopify":
        print("  📌 Product Title:")
        print("    {p} — Elevate Your Everyday".format(p=product))
        print("")
        print("  📌 Brand Story:")
        story = (
            "We believe great products shouldn't be complicated. "
            "Our {p} is designed with one goal: to make your life a little better, "
            "a little easier, a little more joyful. Crafted from premium materials "
            "and refined through countless iterations, it's the kind of product "
            "you'll wonder how you lived without."
        ).format(p=product)
        print(textwrap.fill(story, width=60, initial_indent="    ", subsequent_indent="    "))
        print("")
        print("  📌 Key Features:")
        features = [
            "✦ Thoughtfully designed for daily use",
            "✦ Premium materials, built to last",
            "✦ Minimalist aesthetic, maximum function",
            "✦ Free shipping on all orders",
            "✦ 30-day hassle-free returns",
        ]
        for f in features:
            print("    " + f)
        print("")
        print("  📌 SEO Meta Description:")
        meta = (
            "Shop the {p} — premium quality, minimalist design, "
            "free shipping. Perfect for everyday use or gifting. "
            "Order now with 30-day returns."
        ).format(p=product)
        print("    " + meta)

    print("")

def cmd_generate(product, platform=None):
    print(sep("🛒  完整产品上架文案 — {p}".format(p=product)))
    print("  生成日期: " + today())

    # Titles
    cmd_title(product)

    # Selling points & description
    cmd_desc(product)

    # SEO
    cmd_seo(product)

    # Platform-specific
    platforms = [platform] if platform else ["taobao", "pdd", "amazon", "shopify"]
    print(sep("🌐  平台适配文案"))
    for pf in platforms:
        gen_platform_listing(product, pf)

# ──────────────────────────────────────────────
# Cross-border e-commerce listing
# ──────────────────────────────────────────────

CROSS_BORDER_PLATFORMS = {
    "amazon": {
        "label": "🟡 Amazon",
        "markets": ["美国站", "欧洲站", "日本站"],
    },
    "shopee": {
        "label": "🟠 Shopee",
        "markets": ["东南亚", "台湾站", "巴西站"],
    },
    "aliexpress": {
        "label": "🔴 速卖通 (AliExpress)",
        "markets": ["全球", "俄罗斯", "欧洲"],
    },
}

def cmd_cross_border(product, market):
    market_lower = market.lower()
    print(sep("🌍  跨境电商文案 — {p}".format(p=product)))
    print("  目标市场: {m}".format(m=market))
    print("  生成日期: " + today())
    print("")

    # Amazon listing
    print(sub_sep("🟡 Amazon Listing"))
    print("")
    print("  📌 Product Title (Amazon SEO Optimized):")
    print("    {p} - Premium Quality | Multi-functional | Durable &".format(p=product))
    print("    Portable | Top Rated | Perfect Gift for All Occasions")
    print("")
    print("  📌 Bullet Points (5 Key Features):")
    bullets = [
        "【PREMIUM QUALITY MATERIAL】Crafted from high-grade materials ensuring "
        "long-lasting durability. Our {p} undergoes rigorous quality testing "
        "to meet international standards.".format(p=product),
        "【VERSATILE & MULTI-FUNCTIONAL】Designed for multiple scenarios — "
        "home, office, travel, and outdoor use. One {p} for all your needs.".format(p=product),
        "【ERGONOMIC & USER-FRIENDLY】Intuitive design requires zero learning "
        "curve. Lightweight and portable, easily fits in your bag or pocket.".format(p=product),
        "【PERFECT GIFT CHOICE】Comes in elegant packaging. Ideal for "
        "birthdays, holidays, anniversaries, and corporate gifting.".format(p=product),
        "【100% SATISFACTION GUARANTEED】30-day hassle-free money-back guarantee "
        "+ 12-month warranty + dedicated customer support team.".format(p=product),
    ]
    for i, b in enumerate(bullets, 1):
        print("    {i}. {b}".format(i=i, b=b))
    print("")
    print("  📌 Product Description (A+ Content Framework):")
    print("    ┌─────────────────────────────────────────────┐")
    print("    │  Banner: Lifestyle hero image + tagline     │")
    print("    │  \"Elevate Your Experience with {p}\"  │".format(p=product[:20]))
    print("    ├─────────────────────────────────────────────┤")
    print("    │  Module 1: Brand Story (image left + text)  │")
    print("    │  → Origin, mission, quality commitment      │")
    print("    ├─────────────────────────────────────────────┤")
    print("    │  Module 2: Feature Showcase (3-col grid)    │")
    print("    │  → Icon + title + description per feature   │")
    print("    ├─────────────────────────────────────────────┤")
    print("    │  Module 3: Comparison Chart                 │")
    print("    │  → Our product vs competitors (4 dimensions)│")
    print("    ├─────────────────────────────────────────────┤")
    print("    │  Module 4: Customer Testimonials            │")
    print("    │  → 3 real review excerpts with star ratings │")
    print("    ├─────────────────────────────────────────────┤")
    print("    │  Module 5: FAQ Section                      │")
    print("    │  → Top 3 questions answered                 │")
    print("    └─────────────────────────────────────────────┘")
    print("")
    print("  📌 Backend Search Terms:")
    print("    {p}, best {p}, premium {p}, {p} gift,".format(p=product))
    print("    {p} for home, {p} portable, top rated {p},".format(p=product))
    print("    {p} 2024, {p} professional, {p} set".format(p=product))
    print("")

    # Shopee listing
    print(sub_sep("🟠 Shopee Listing"))
    print("")
    print("  📌 标题 (Shopee SEO):")
    print("    [{p}] 🔥Hot Sale Premium Quality Free Shipping".format(p=product))
    print("    100% Original Ready Stock Fast Delivery 现货包邮")
    print("")
    print("  📌 商品描述:")
    print("    🌟 Why Choose Our {p}? 🌟".format(p=product))
    print("    ✅ 100% Brand New & High Quality")
    print("    ✅ Ready Stock — Ships within 24 hours")
    print("    ✅ Free Shipping / 包邮到家")
    print("    ✅ Cash on Delivery Available (COD)")
    print("    ✅ 7 Days Easy Return")
    print("")
    print("    📦 Package Includes:")
    print("    • 1x {p}".format(p=product))
    print("    • 1x User Manual")
    print("    • 1x Gift Box Packaging")
    print("")
    print("    ⚠️ Notes:")
    print("    • Due to lighting/monitor differences, slight color")
    print("      variation is normal")
    print("    • Manual measurement, 1-3cm error is acceptable")
    print("")
    print("  📌 Shopee 活动标签:")
    print("    #FreeShipping #ReadyStock #BestPrice #{p}".format(
        p=product.replace(" ", "")))
    print("    #HotSale #TopRated #COD #FastDelivery")
    print("")

    # AliExpress listing
    print(sub_sep("🔴 速卖通 AliExpress Listing"))
    print("")
    print("  📌 Title:")
    print("    New {p} High Quality Professional Grade".format(p=product))
    print("    Multi-purpose Portable Free Shipping Worldwide")
    print("")
    print("  📌 Key Attributes:")
    print("    • Origin: CN (Mainland China)")
    print("    • Brand: [Your Brand]")
    print("    • Material: Premium Grade")
    print("    • Feature: Multi-functional")
    print("    • Application: Home / Office / Travel / Gift")
    print("")
    print("  📌 Description (Russian/Spanish Bilingual Tip):")
    print("    Include descriptions in top buyer languages:")
    print("    • English (primary)")
    print("    • Russian: Высококачественный {p}".format(p=product))
    print("    • Spanish: {p} de alta calidad".format(p=product))
    print("    • Portuguese: {p} de alta qualidade".format(p=product))
    print("")
    print("  📌 Shipping Templates:")
    print("    • ePacket (7-15 days) — Free")
    print("    • AliExpress Standard (15-30 days) — Free")
    print("    • DHL/FedEx (5-10 days) — Paid upgrade")
    print("")

def cmd_video_script(product):
    print(sep("🎬  产品短视频脚本 — {p}".format(p=product)))
    print("  时长: 30-60秒 | 适用平台: 抖音/TikTok/Reels/YouTube Shorts")
    print("  生成日期: " + today())
    print("")

    scenes = [
        {
            "time": "0-3秒",
            "type": "⚡ 黄金开头 (Hook)",
            "visual": "产品特写，快速旋转展示 / 或痛点场景再现",
            "narration": "你还在为 [痛点] 烦恼吗？这款{p}彻底解决！".format(p=product),
            "subtitle": "🔥 99%的人不知道的好物",
            "bgm": "紧张感音效 → 转场音效",
        },
        {
            "time": "3-8秒",
            "type": "😫 痛点放大",
            "visual": "展示没有产品时的困扰场景（真实感）",
            "narration": "以前每次 [痛点场景描述]，真的太崩溃了...",
            "subtitle": "你是不是也这样？👇",
            "bgm": "低沉/压抑背景音",
        },
        {
            "time": "8-15秒",
            "type": "✨ 产品登场",
            "visual": "产品从包装中取出，慢动作展示外观细节",
            "narration": "直到我发现了这款{p}，一切都变了！".format(p=product),
            "subtitle": "改变生活的神器 ✨",
            "bgm": "转场 → 轻快上扬音乐",
        },
        {
            "time": "15-30秒",
            "type": "🔍 功能展示 (核心卖点)",
            "visual": "分3个镜头展示核心功能，每个功能5秒\n"
                     "             镜头A: 功能1 使用特写\n"
                     "             镜头B: 功能2 对比展示（有vs无）\n"
                     "             镜头C: 功能3 效果呈现",
            "narration": "卖点1：[具体功能]，再也不用担心...\n"
                        "                    卖点2：[具体功能]，效率提升200%\n"
                        "                    卖点3：[具体功能]，用过都说好",
            "subtitle": "✅ 卖点1  ✅ 卖点2  ✅ 卖点3",
            "bgm": "节奏感强的轻快音乐，每个卖点切换时加音效",
        },
        {
            "time": "30-40秒",
            "type": "📊 信任背书",
            "visual": "展示好评截图/销量数据/质检报告/明星同款",
            "narration": "已经有超过10万人在用，好评率98%！".format(p=product),
            "subtitle": "💰 10万+用户的选择",
            "bgm": "继续轻快音乐",
        },
        {
            "time": "40-50秒",
            "type": "🎁 促销信息",
            "visual": "价格标签动画，划线价→优惠价，倒计时效果",
            "narration": "现在下单还有专属优惠，前100名再减30！",
            "subtitle": "⏰ 限时特惠 ¥XX（原价¥XX）",
            "bgm": "紧迫感音效",
        },
        {
            "time": "50-60秒",
            "type": "📢 行动号召 (CTA)",
            "visual": "产品居中，购买链接/二维码叠加，手指点击动画",
            "narration": "点击下方链接，马上抢购！手慢无！",
            "subtitle": "👇 点击购买 | 评论区有惊喜",
            "bgm": "结尾音效 + 品牌jingle",
        },
    ]

    for i, scene in enumerate(scenes, 1):
        print(sub_sep("Scene {i}: {type} [{time}]".format(
            i=i, type=scene["type"], time=scene["time"])))
        print("")
        print("  🎥 画面: {v}".format(v=scene["visual"]))
        print("")
        print("  🎙️ 旁白: {n}".format(n=scene["narration"]))
        print("")
        print("  📝 字幕: {s}".format(s=scene["subtitle"]))
        print("")
        print("  🎵 BGM:  {b}".format(b=scene["bgm"]))
        print("")

    print(sub_sep("📋 拍摄清单"))
    print("")
    print("  📷 设备:")
    print("    • 手机/相机 + 三脚架")
    print("    • 补光灯（柔光）")
    print("    • 收音麦克风（口播用）")
    print("")
    print("  🎨 道具:")
    print("    • {p} 产品实物".format(p=product))
    print("    • 纯色背景布（白/浅灰）")
    print("    • 使用场景道具（根据产品调整）")
    print("    • 价格标签/促销贴纸")
    print("")
    print("  ✂️ 后期:")
    print("    • 剪映/CapCut 剪辑")
    print("    • 添加字幕（自动识别+手动校对）")
    print("    • 转场特效（推荐：缩放、滑动）")
    print("    • 背景音乐节奏对齐画面切换")
    print("")

def cmd_faq(product):
    print(sep("❓  常见问题FAQ — {p}".format(p=product)))
    print("  适用场景: 电商详情页 / 客服话术 / 产品手册")
    print("  生成日期: " + today())
    print("")

    faqs = [
        {
            "q": "{p}的材质是什么？质量怎么样？".format(p=product),
            "a": "我们的{p}采用优质环保材料，经过严格质检，符合国家标准。"
                 "每一件产品都经过48小时耐久测试，确保品质可靠。".format(p=product),
        },
        {
            "q": "这款{p}和市面上其他品牌有什么区别？".format(p=product),
            "a": "核心区别在三点：① 用料更扎实，同价位中品质最优；"
                 "② 设计更人性化，解决了同类产品常见的[痛点]问题；"
                 "③ 售后更完善，提供1年质保+终身技术支持。",
        },
        {
            "q": "发货时间是多久？用什么快递？",
            "a": "下单后48小时内发货（工作日），默认顺丰/京东物流。"
                 "全国大部分地区2-3天到达，偏远地区3-5天。支持查看物流实时状态。",
        },
        {
            "q": "可以退换货吗？退货流程是怎样的？",
            "a": "支持7天无理由退换！收到商品如不满意，联系客服即可办理。"
                 "退货运费由我们承担（质量问题），非质量问题退货运费需自理。"
                 "退款1-3个工作日到账。",
        },
        {
            "q": "{p}适合送礼吗？有礼盒包装吗？".format(p=product),
            "a": "非常适合！我们提供精美礼盒包装，还可附赠贺卡（下单时备注）。"
                 "无论是生日、节日还是商务送礼，都很体面。",
        },
        {
            "q": "第一次使用{p}，有使用说明吗？".format(p=product),
            "a": "有的。包装内附详细使用说明书（中英双语），同时我们提供：\n"
                 "      • 视频教程（扫码观看）\n"
                 "      • 一对一客服指导\n"
                 "      • 常见问题在线文档",
        },
        {
            "q": "买了多件可以有优惠吗？支持批发吗？",
            "a": "当然！2件95折，3件9折，5件以上联系客服享批发价。"
                 "企业/团体采购可开增值税发票，量大另议。",
        },
        {
            "q": "{p}的保修期是多久？坏了怎么办？".format(p=product),
            "a": "提供1年质保服务。保修期内非人为损坏，免费维修或更换。"
                 "保修期外也提供有偿维修服务，配件终身供应。"
                 "联系客服即可走售后流程。",
        },
        {
            "q": "你们是正品吗？有没有授权证明？",
            "a": "100%正品保障，假一赔十！我们是品牌官方授权经销商，"
                 "支持扫码验真。详情页底部可查看品牌授权书。",
        },
        {
            "q": "有没有使用{p}的真实用户评价？".format(p=product),
            "a": "目前已有10万+用户购买，好评率98%以上。您可以查看：\n"
                 "      • 商品评论区的真实评价和买家秀\n"
                 "      • 社交媒体上的用户分享（搜索#{p}）\n".format(p=product) +
                 "      • 详情页的视频评测",
        },
        {
            "q": "下单后可以修改地址/取消订单吗？",
            "a": "发货前可以！联系客服提供订单号即可修改。"
                 "已发货的订单可以选择拒收后退款。建议下单时仔细核对地址。",
        },
        {
            "q": "你们有线下门店吗？可以体验后再买吗？",
            "a": "目前以线上销售为主，暂无线下门店。"
                 "但我们提供7天无理由退换，相当于免费体验期！"
                 "不满意随时退，零风险。",
        },
    ]

    for i, faq in enumerate(faqs, 1):
        print("  ─── Q{i} ───".format(i=i))
        print("  ❓ {q}".format(q=faq["q"]))
        print("")
        print("  💡 {a}".format(a=faq["a"]))
        print("")

    print(sub_sep("📋 FAQ 使用建议"))
    print("")
    print("  • 电商详情页: 放在页面底部，减少咨询量")
    print("  • 客服培训: 作为标准话术模板")
    print("  • 社群运营: 置顶群公告 / 自动回复设置")
    print("  • 产品手册: 附在说明书最后")
    print("")

def cmd_bundle(products_str):
    products = [p.strip() for p in products_str.split(",") if p.strip()]
    if len(products) < 2:
        print("Error: at least 2 products required (comma-separated).", file=sys.stderr)
        sys.exit(1)

    bundle_name = " + ".join(products)
    print(sep("🎁  组合套装文案 — {b}".format(b=bundle_name)))
    print("  套装组成: {n} 件组合".format(n=len(products)))
    print("  生成日期: " + today())
    print("")

    print(sub_sep("🏷️  套装标题 (5个变体)"))
    print("")
    titles = [
        "【超值套装】{b} 组合装 买套装更划算 一站式解决方案".format(b=bundle_name),
        "【省心之选】{b} 搭配套餐 原价¥XXX 套装价¥XXX".format(b=bundle_name),
        "【达人推荐】{b} 黄金搭档 一套搞定 新手必入".format(b=bundle_name),
        "【限时组合】{b} 捆绑优惠 单买不如买套装".format(b=bundle_name),
        "【送礼首选】{b} 豪华礼盒装 有面子又实用".format(b=bundle_name),
    ]
    for i, t in enumerate(titles, 1):
        print("    {i}. {t}".format(i=i, t=t))
    print("")

    print(sub_sep("✨  套装卖点"))
    print("")
    print("  💰 价格优势:")
    print("    • 单买总价: ¥XXX")
    print("    • 套装价:   ¥XXX (省 ¥XX，相当于白送1件)")
    print("    • 限时再减: 前50名下单额外减¥XX")
    print("")
    print("  🎯 搭配逻辑:")
    for i, p in enumerate(products, 1):
        roles = ["基础款 — 解决核心需求", "进阶款 — 提升使用体验",
                 "配件款 — 完善整体方案", "赠品款 — 超值附加价值"]
        role = roles[min(i-1, len(roles)-1)]
        print("    {i}. {p} → {r}".format(i=i, p=p, r=role))
    print("")
    print("  📦 套装专属福利:")
    print("    • 🎁 专属礼盒包装（普通单品无此待遇）")
    print("    • 📋 搭配使用指南（教你怎么配合使用效果最佳）")
    print("    • 🔧 专属客服通道（优先响应）")
    print("    • 💳 支持分期免息（3期/6期）")
    print("")

    print(sub_sep("📝  套装详情文案"))
    print("")
    print("  为什么要买套装？")
    print("")
    print("  ❌ 单买的烦恼:")
    print("    • 东拼西凑，不确定是否搭配")
    print("    • 分开购买运费多花")
    print("    • 错过组合优惠价")
    print("")
    print("  ✅ 套装的优势:")
    print("    • 专业搭配，买回去直接用")
    print("    • 一个包裹到家，省时省力")
    print("    • 套装专属价，比单买省 XX%")
    print("    • 礼盒包装，送人有面子")
    print("")

    print(sub_sep("🌐  多平台标题适配"))
    print("")
    print("  淘宝: 【官方旗舰】{b} 超值套装 限时折扣 顺丰包邮".format(b=bundle_name))
    print("  拼多多: {b} 组合装 工厂直发 全网最低 拼团更优惠".format(b=bundle_name))
    print("  Amazon: {b} Bundle Set | Premium Combo Pack | Save XX% | Gift Ready".format(
        b=" & ".join(products)))
    print("  Shopee: [{b}] Bundle Deal 🔥 Free Shipping Ready Stock".format(
        b=" + ".join(products)))
    print("")

# ──────────────────────────────────────────────
# Title Optimization (痛点: 曝光不够)
# ──────────────────────────────────────────────

def cmd_optimize(current_title):
    print(sep("🔧  标题优化诊断 — 现有标题分析"))
    print("")
    print("  📌 原标题: {t}".format(t=current_title))
    print("")

    # Analyze problems
    title_len = len(current_title)
    issues = []

    if title_len < 15:
        issues.append("⚠️ 标题过短({n}字)，建议25-60字，充分利用搜索权重".format(n=title_len))
    elif title_len > 65:
        issues.append("⚠️ 标题过长({n}字)，超出大多数平台展示限制，建议精简到60字以内".format(n=title_len))
    else:
        issues.append("✅ 标题长度适中({n}字)".format(n=title_len))

    has_brackets = "[" in current_title or "【" in current_title
    if not has_brackets:
        issues.append("⚠️ 缺少修饰符号（如【】），无法在搜索结果中突出重点")
    else:
        issues.append("✅ 使用了修饰符号，有助于吸引点击")

    hot_words = ["新款", "热销", "爆款", "正品", "包邮", "限时", "特惠", "旗舰"]
    found_hot = [w for w in hot_words if w in current_title]
    missing_hot = [w for w in hot_words if w not in current_title]
    if not found_hot:
        issues.append("⚠️ 缺少流量热词（如新款/热销/爆款/正品），搜索曝光受限")
    else:
        issues.append("✅ 包含热词: {w}".format(w="、".join(found_hot)))

    has_year = any(y in current_title for y in ["2024", "2025", "2026"])
    if not has_year:
        issues.append("⚠️ 缺少年份标签，加入「2025新款」可提升时效性搜索排名")

    selling_words = ["防水", "静音", "轻便", "大容量", "高清", "智能", "便携", "无线", "快充"]
    found_sell = [w for w in selling_words if w in current_title]
    if not found_sell:
        issues.append("⚠️ 缺少卖点属性词（如防水/静音/便携），无法精准匹配买家需求")
    else:
        issues.append("✅ 包含属性词: {w}".format(w="、".join(found_sell)))

    scene_words = ["家用", "办公", "户外", "旅行", "送礼", "学生", "儿童", "商务"]
    found_scene = [w for w in scene_words if w in current_title]
    if not found_scene:
        issues.append("⚠️ 缺少场景词（如家用/办公/送礼），错失场景搜索流量")

    print(sub_sep("📋 标题诊断结果"))
    print("")
    for issue in issues:
        print("  " + issue)
    print("")

    # Generate 5 optimized titles
    # Extract core product name (use the whole title if short)
    core = current_title.strip()
    if len(core) > 20:
        # Try to extract a shorter core
        import re as _re
        parts = _re.split(r'[【】\[\]\\s]+', core)
        parts = [p.strip() for p in parts if p.strip() and len(p.strip()) > 2]
        core = parts[0] if parts else core[:15]

    print(sub_sep("✨ 5个优化版标题"))
    print("")
    optimized = [
        "【2025新款】{c} 热销爆款 品质升级 多功能 家用办公两不误 限时特惠".format(c=core),
        "【旗舰正品】{c} 高性价比 好评10万+ 送礼自用首选 顺丰包邮".format(c=core),
        "{c} 2025升级款 静音防水 便携设计 学生白领必备 厂家直销".format(c=core),
        "【限时秒杀】{c} 大品牌品质 小众价格 买一送一 库存紧张速抢".format(c=core),
        "【口碑推荐】{c} 专业级品质 轻便耐用 适合送礼 7天无理由退换".format(c=core),
    ]
    for i, t in enumerate(optimized, 1):
        print("  {i}. {t}".format(i=i, t=t))
        print("     (字数: {n})".format(n=len(t)))
        print("")

    print(sub_sep("🎯 关键词布局建议"))
    print("")
    print("  标题关键词应遵循以下顺序排列：")
    print("")
    print("  ┌────────────────────────────────────────────────┐")
    print("  │  1️⃣  核心词     产品名称本身（如：蓝牙耳机）   │")
    print("  │  2️⃣  属性词     功能/材质/规格（如：降噪 无线） │")
    print("  │  3️⃣  场景词     使用场景（如：运动 办公 送礼）  │")
    print("  │  4️⃣  长尾词     精准需求（如：跑步不掉 续航久） │")
    print("  │  5️⃣  修饰词     营销热词（如：爆款 热销 新款）  │")
    print("  └────────────────────────────────────────────────┘")
    print("")
    print("  💡 标题优化口诀:")
    print("    • 核心词放最前，权重最高")
    print("    • 属性词紧跟，精准匹配")
    print("    • 场景词覆盖需求长尾流量")
    print("    • 修饰词放最后，吸引点击")
    print("    • 避免堆砌重复词，每个词只出现一次")
    print("    • 标题控制在25-60字最佳")
    print("")

# ──────────────────────────────────────────────
# Pain Point Mining (痛点: 不知道用户在意什么)
# ──────────────────────────────────────────────

def cmd_pain(category):
    print(sep("🔍  用户痛点挖掘 — {c}".format(c=category)))
    print("  品类: {c}".format(c=category))
    print("  生成日期: " + today())
    print("")

    # Universal pain points mapped to categories
    pain_points = [
        {
            "rank": 1,
            "pain": "质量不过关 / 材质差",
            "detail": "用户最核心的担忧。便宜没好货？实物和图片差距大？",
            "copy_angle": "从材质入手：「精选XX材质，通过XX认证」「实拍无滤镜，所见即所得」",
            "complaint": "差评高频词：质量差、做工粗糙、用了就坏、和图片不一样"
        },
        {
            "rank": 2,
            "pain": "不知道适不适合自己",
            "detail": "尺码选错？型号不对？买回来不合用？",
            "copy_angle": "降低选择门槛：「附尺码对照表」「在线客服1v1推荐」「不合适包退」",
            "complaint": "差评高频词：尺码不准、买大了/买小了、不适合我"
        },
        {
            "rank": 3,
            "pain": "价格不透明 / 怕买贵了",
            "detail": "到处比价，担心买亏。同样的东西别家更便宜？",
            "copy_angle": "打消价格顾虑：「全网比价 买贵退差」「厂家直供 省去中间商」",
            "complaint": "差评高频词：不值这个价、太贵了、活动价更低"
        },
        {
            "rank": 4,
            "pain": "物流太慢 / 包装破损",
            "detail": "等太久影响体验。收到已经破损心情差。",
            "copy_angle": "物流承诺：「顺丰/京东 最快次日达」「加厚包装 三层防护」",
            "complaint": "差评高频词：发货慢、快递暴力、到手就是坏的"
        },
        {
            "rank": 5,
            "pain": "售后无保障 / 退换难",
            "detail": "出问题找不到人？退货扯皮？",
            "copy_angle": "售后兜底：「7天无理由 运费我出」「1年质保 终身维修」「专属客服秒回」",
            "complaint": "差评高频词：客服不回、退货扣钱、售后态度差"
        },
        {
            "rank": 6,
            "pain": "功能不如预期 / 鸡肋",
            "detail": "宣传很好，实际鸡肋。核心功能不好用。",
            "copy_angle": "真实体验：「100人实测视频」「功能逐一演示」「不满意直接退」",
            "complaint": "差评高频词：没什么用、功能单一、宣传过度"
        },
        {
            "rank": 7,
            "pain": "安全/健康隐患",
            "detail": "材料有没有毒？小孩用安全吗？食品级？",
            "copy_angle": "安全背书：「通过SGS/CMA检测」「食品级材质」「母婴可用」",
            "complaint": "差评高频词：有异味、不放心给孩子用、没有检测报告"
        },
        {
            "rank": 8,
            "pain": "外观/颜值不行",
            "detail": "丑的东西没人买。颜色色差大。",
            "copy_angle": "颜值种草：「XX设计师联名」「ins风/极简风」「多色可选 总有你的菜」",
            "complaint": "差评高频词：好丑、颜色不对、和想象不一样"
        },
        {
            "rank": 9,
            "pain": "不会用 / 上手难",
            "detail": "买回来不会组装？功能太复杂看不懂？",
            "copy_angle": "降低上手难度：「3分钟上手」「扫码看视频教程」「真人客服远程指导」",
            "complaint": "差评高频词：看不懂说明书、太复杂了、没有教程"
        },
        {
            "rank": 10,
            "pain": "缺少社交证明 / 不确定口碑",
            "detail": "评价是不是刷的？真实用户怎么说？",
            "copy_angle": "信任建设：「已售XX万件」「真实买家秀」「明星/达人同款」",
            "complaint": "差评高频词：评价不可信、和评价说的不一样"
        },
    ]

    print(sub_sep("📊 {c} — 用户TOP10痛点与关注点".format(c=category)))
    print("")
    for p in pain_points:
        print("  ─── 痛点 #{rank} ───".format(rank=p["rank"]))
        print("  😣 痛点: {pain}".format(pain=p["pain"]))
        print("  📝 详解: {detail}".format(detail=p["detail"]))
        print("  ✍️  文案切入: {angle}".format(angle=p["copy_angle"]))
        print("  ❌ 差评雷区: {complaint}".format(complaint=p["complaint"]))
        print("")

    print(sub_sep("⚡ {c} — 差评避雷清单".format(c=category)))
    print("")
    print("  在写listing之前，先检查这些常见翻车点：")
    print("")
    print("  │ 雷区                    │ 如何在文案中化解               │")
    print("  │─────────────────────────│────────────────────────────────│")
    print("  │ 实物与图片不符          │ 标注「实拍图」「无滤镜」       │")
    print("  │ 尺码/规格描述不清       │ 加尺码表 + 真人试穿参考        │")
    print("  │ 夸大宣传               │ 用数据说话，少用绝对词          │")
    print("  │ 售后流程不明            │ 在详情页写清退换流程            │")
    print("  │ 缺少使用说明            │ 附视频教程二维码               │")
    print("  │ 包装简陋               │ 文案中强调「精美礼盒包装」      │")
    print("")

    print(sub_sep("💡 文案优化建议"))
    print("")
    print("  1. 先看竞品差评 → 提取TOP3痛点 → 在文案中提前化解")
    print("  2. 卖点不要自嗨，要解决用户真实顾虑")
    print("  3. 每个卖点对应一个痛点：用户怕X → 我们Y")
    print("  4. 在标题中体现核心痛点的解决方案（如「静音」「防水」）")
    print("  5. 详情页第一屏就放用户最关心的痛点化解")
    print("")

# ──────────────────────────────────────────────
# Main dispatcher
# ──────────────────────────────────────────────

def main():
    args = sys.argv[1:]
    if not args:
        print("Error: no command provided. Run with 'help' for usage.", file=sys.stderr)
        sys.exit(1)

    cmd = args[0]

    if cmd == "title":
        if len(args) < 2:
            print("Error: product name required.", file=sys.stderr)
            sys.exit(1)
        cmd_title(args[1])

    elif cmd == "seo":
        if len(args) < 2:
            print("Error: product name required.", file=sys.stderr)
            sys.exit(1)
        cmd_seo(args[1])

    elif cmd == "desc":
        if len(args) < 2:
            print("Error: product name required.", file=sys.stderr)
            sys.exit(1)
        cmd_desc(args[1])

    elif cmd == "compare":
        if len(args) < 3:
            print("Error: two product names required.", file=sys.stderr)
            sys.exit(1)
        cmd_compare(args[1], args[2])

    elif cmd == "generate":
        if len(args) < 2:
            print("Error: product name required.", file=sys.stderr)
            sys.exit(1)
        product = args[1]
        platform = None
        # parse --platform
        i = 2
        while i < len(args):
            if args[i] == "--platform" and i + 1 < len(args):
                platform = args[i + 1].lower()
                valid = ["taobao", "pdd", "amazon", "shopify"]
                if platform not in valid:
                    print("Error: platform must be one of: {v}".format(v=", ".join(valid)), file=sys.stderr)
                    sys.exit(1)
                i += 2
            else:
                i += 1
        cmd_generate(product, platform)

    elif cmd == "cross-border":
        if len(args) < 3:
            print("Error: product name and target market required.", file=sys.stderr)
            print("Usage: product.sh cross-border \"产品\" \"目标市场\"", file=sys.stderr)
            sys.exit(1)
        cmd_cross_border(args[1], args[2])

    elif cmd == "video-script":
        if len(args) < 2:
            print("Error: product name required.", file=sys.stderr)
            sys.exit(1)
        cmd_video_script(args[1])

    elif cmd == "faq":
        if len(args) < 2:
            print("Error: product name required.", file=sys.stderr)
            sys.exit(1)
        cmd_faq(args[1])

    elif cmd == "bundle":
        if len(args) < 2:
            print("Error: product list required (comma-separated).", file=sys.stderr)
            sys.exit(1)
        cmd_bundle(args[1])

    elif cmd == "optimize":
        if len(args) < 2:
            print("Error: current title required.", file=sys.stderr)
            sys.exit(1)
        cmd_optimize(args[1])

    elif cmd == "pain":
        if len(args) < 2:
            print("Error: product category required.", file=sys.stderr)
            sys.exit(1)
        cmd_pain(args[1])

    else:
        print("Unknown command: {c}. Run with 'help' for usage.".format(c=cmd), file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
PYTHON_SCRIPT
}

# ── Main entry ──────────────────────────────
case "${1:-help}" in
    help|-h|--help)
        show_help
        ;;
    title|seo|desc|compare|generate|cross-border|video-script|faq|bundle|optimize|pain)
        run_python "$@"
        ;;
    *)
        echo "Unknown command: $1" >&2
        echo "Run 'product.sh help' for usage." >&2
        exit 1
        ;;
esac
echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
