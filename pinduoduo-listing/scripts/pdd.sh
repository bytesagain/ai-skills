#!/usr/bin/env bash
# pdd.sh - 拼多多商品标题和文案生成器
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CMD="${1:-help}"
shift 2>/dev/null || true

python3 - "$CMD" "$@" << 'PYTHON_EOF'
# -*- coding: utf-8 -*-
import sys
import random

def show_help():
    print("""
====================================
  拼多多文案生成器 pdd.sh
====================================

用法:
  pdd.sh title "产品名" "关键词1,关键词2"     拼多多标题（强调性价比）
  pdd.sh desc "产品名"                       商品描述（突出实惠、划算）
  pdd.sh group "产品名" "价格"                拼团文案
  pdd.sh compare "产品名" "竞品价格"           价格对比文案
  pdd.sh price-war "产品名" "竞品价格"         价格策略（定价+凑单满减设计）
  pdd.sh review-reply "评价类型"              评价回复（好评/差评/追评）
  pdd.sh seckill "产品名"                    秒杀/限时购文案
  pdd.sh help                                显示本帮助

示例:
  pdd.sh title "无线充电器" "快充,苹果,安卓通用"
  pdd.sh desc "无线充电器"
  pdd.sh group "无线充电器" "29.9"
  pdd.sh compare "无线充电器" "99"
  pdd.sh price-war "无线充电器" "89"
  pdd.sh review-reply "好评"
  pdd.sh review-reply "差评"
  pdd.sh seckill "无线充电器"
""")

def gen_title(product, keywords_str):
    keywords = [k.strip() for k in keywords_str.split(",") if k.strip()]

    print("=" * 50)
    print("  拼多多爆款标题生成 - {}".format(product))
    print("=" * 50)
    print("")
    print("关键词: {}".format(", ".join(keywords)))
    print("")

    pdd_prefixes = ["【百亿补贴】", "【限时秒杀】", "【工厂直发】", "【全网最低】", "【今日特价】", "【拼团价】"]
    pdd_modifiers = ["超值", "特惠", "划算", "实惠", "厂家直销", "批发价", "清仓"]
    pdd_suffixes = ["包邮", "买一送一", "限时抢购", "拼团更便宜", "厂家直发"]

    for i in range(5):
        prefix = random.choice(pdd_prefixes)
        mod = random.choice(pdd_modifiers)
        kw_sample = random.sample(keywords, min(len(keywords), random.randint(1, max(1, len(keywords)))))
        suffix = random.choice(pdd_suffixes)
        title = "{prefix}{product} {mod} {kws} {suffix}".format(
            prefix=prefix, product=product, mod=mod,
            kws=" ".join(kw_sample), suffix=suffix
        )
        if len(title) > 30:
            title = title[:30]
        print("标题{num}: {title}".format(num=i+1, title=title))
        print("  字数: {n}字".format(n=len(title)))
        print("")

    print("💡 拼多多标题技巧:")
    print("  - 突出「价格优势」和「性价比」")
    print("  - 加入「百亿补贴」「工厂直发」等拼多多特色词")
    print("  - 关键词覆盖要广，利于搜索曝光")
    print("  - 避免敏感词和极限词（最、第一等）")

def gen_desc(product):
    print("=" * 50)
    print("  拼多多商品描述 - {}".format(product))
    print("=" * 50)
    print("")

    descs = [
        {
            "style": "实惠型",
            "text": (
                "🔥 {product} | 工厂直发，省去中间商差价！\n\n"
                "💰 为什么我们的价格这么低？\n"
                "因为我们是厂家直营！没有经销商加价，没有品牌溢价，\n"
                "把省下来的钱全部让利给消费者！\n\n"
                "✅ 品质保证\n"
                "  · 与大牌同厂同线生产\n"
                "  · 严格质检，残次品绝不出厂\n"
                "  · 支持7天无理由退换\n\n"
                "✅ 超值体验\n"
                "  · 买到就是赚到\n"
                "  · 自用送人都合适\n"
                "  · 拼团价更便宜\n\n"
                "📦 全国包邮 | 48小时发货 | 售后无忧"
            ).format(product=product),
        },
        {
            "style": "促销型",
            "text": (
                "🎉 {product} 限时特惠，手慢无！\n\n"
                "⏰ 活动时间有限，抢完即恢复原价！\n\n"
                "🌟 产品亮点:\n"
                "  1. 大牌品质，平民价格\n"
                "  2. 厂家直供，品质看得见\n"
                "  3. 老客复购率超高，好评如潮\n"
                "  4. 拼团购买更划算\n\n"
                "💪 我们的承诺:\n"
                "  ✅ 正品保障，假一赔十\n"
                "  ✅ 7天无理由退换\n"
                "  ✅ 全国包邮（偏远地区除外）\n"
                "  ✅ 专业客服，有问必答\n\n"
                "👉 别犹豫了，这个价格真的不会再有了！"
            ).format(product=product),
        },
        {
            "style": "口碑型",
            "text": (
                "📢 {product} | 10万+买家的共同选择！\n\n"
                "💬 买家真实评价:\n"
                "  「这个价格能买到这个品质，真的绝了」\n"
                "  「已经是第三次回购了，品质稳定」\n"
                "  「推荐给朋友，都说物超所值」\n"
                "  「比实体店便宜太多了，品质一样」\n\n"
                "📊 数据说话:\n"
                "  · 累计销量 100000+\n"
                "  · 好评率 98.6%\n"
                "  · 复购率 45%\n\n"
                "🤝 我们的底气:\n"
                "  源头厂家 → 没有中间商 → 价格最实惠\n"
                "  严格品控 → 出厂必检 → 品质有保障\n\n"
                "  这就是为什么大家都选我们的{product}！"
            ).format(product=product),
        },
    ]

    for i, d in enumerate(descs):
        print("版本{} [{}]:".format(i + 1, d["style"]))
        print(d["text"])
        print("")
        print("-" * 50)
        print("")

    print("💡 拼多多描述技巧:")
    print("  - 强调性价比，让用户觉得「超值」")
    print("  - 多用emoji和分段，提高可读性")
    print("  - 加入买家评价/数据增加信任感")
    print("  - 制造紧迫感，促进立即下单")

def gen_group(product, price):
    print("=" * 50)
    print("  拼团文案 - {}".format(product))
    print("  拼团价: {}元".format(price))
    print("=" * 50)
    print("")

    try:
        price_num = float(price)
        original_price = round(price_num * random.uniform(2.0, 3.5), 1)
        save = round(original_price - price_num, 1)
    except (ValueError, TypeError):
        price_num = 0
        original_price = 0
        save = 0

    templates = [
        {
            "style": "紧迫型",
            "text": (
                "🔥🔥🔥 {product} 拼团特惠！\n\n"
                "💰 原价: ¥{original}  →  拼团价: ¥{price}\n"
                "💸 立省: ¥{save}！\n\n"
                "⏰ 仅剩最后50个名额！\n"
                "👥 已有2846人参与拼团\n\n"
                "🎯 拼团规则:\n"
                "  · 2人即可成团\n"
                "  · 24小时内未成团自动退款\n"
                "  · 拼团成功立享超低价\n\n"
                "👉 赶紧叫上好友一起拼！"
            ).format(product=product, price=price, original=original_price, save=save),
        },
        {
            "style": "分享型",
            "text": (
                "📣 好物分享！{product}拼团价只要¥{price}！\n\n"
                "原价¥{original}的{product}，\n"
                "现在拼团只要¥{price}，省了¥{save}！\n\n"
                "💡 分享给朋友一起买更划算:\n"
                "  · 自用省钱\n"
                "  · 送人体面\n"
                "  · 拼团还能赚优惠券\n\n"
                "🔗 长按分享给好友，一起拼更划算！\n"
                "⏰ 限时活动，拼完即止！"
            ).format(product=product, price=price, original=original_price, save=save),
        },
        {
            "style": "社交型",
            "text": (
                "💬 「你们那个{product}多少钱买的？」\n"
                "💬 「¥{price}！拼多多拼团买的！」\n"
                "💬 「这么便宜？！链接给我！」\n\n"
                "😏 这就是拼团的魅力！\n\n"
                "原价 ¥{original} 的{product}\n"
                "拼团价只要 ¥{price}\n"
                "省下的 ¥{save} 够吃好几顿饭了！\n\n"
                "👥 找个小伙伴一起拼吧！\n"
                "拼成就发货，拼不成全额退款，零风险！"
            ).format(product=product, price=price, original=original_price, save=save),
        },
    ]

    for i, t in enumerate(templates):
        print("方案{} [{}]:".format(i + 1, t["style"]))
        print(t["text"])
        print("")
        print("-" * 50)
        print("")

    print("💡 拼团文案技巧:")
    print("  - 突出价格对比，让省钱一目了然")
    print("  - 制造紧迫感（限量、限时）")
    print("  - 降低分享门槛（2人成团）")
    print("  - 强调零风险（不成团退款）")

def gen_compare(product, competitor_price):
    print("=" * 50)
    print("  价格对比文案 - {}".format(product))
    print("  竞品价格: ¥{}".format(competitor_price))
    print("=" * 50)
    print("")

    try:
        comp_price = float(competitor_price)
        our_prices = [
            round(comp_price * 0.3, 1),
            round(comp_price * 0.4, 1),
            round(comp_price * 0.5, 1),
        ]
    except (ValueError, TypeError):
        comp_price = 100
        our_prices = [30, 40, 50]

    templates = [
        {
            "style": "直接对比型",
            "text": (
                "📊 {product} 价格大对比！\n\n"
                "某猫旗舰店: ¥{comp}\n"
                "某东自营:   ¥{comp2}\n"
                "我们的价格: ¥{our} 🔥\n\n"
                "同样的{product}，同样的品质，\n"
                "我们直接省了 ¥{save}！\n\n"
                "💡 为什么这么便宜？\n"
                "  ✅ 工厂直发，0中间商\n"
                "  ✅ 不打广告，省下推广费\n"
                "  ✅ 薄利多销，走量取胜\n\n"
                "品质一样，价格砍半，何必多花冤枉钱？"
            ).format(
                product=product, comp=comp_price,
                comp2=round(comp_price * 0.9, 1),
                our=our_prices[1], save=round(comp_price - our_prices[1], 1)
            ),
        },
        {
            "style": "算账型",
            "text": (
                "🧮 帮你算笔账！{product}\n\n"
                "别家卖 ¥{comp}，我们卖 ¥{our}\n"
                "省下 ¥{save}，你可以：\n"
                "  🍜 吃 {meals} 顿好的\n"
                "  🎬 看 {movies} 场电影\n"
                "  ☕ 喝 {coffees} 杯奶茶\n\n"
                "同样品质为什么要多花钱？\n"
                "省下来的钱改善生活不好吗？\n\n"
                "精打细算不是抠门，是聪明！\n"
                "👉 聪明人都在拼多多买{product}！"
            ).format(
                product=product, comp=comp_price,
                our=our_prices[1], save=round(comp_price - our_prices[1], 1),
                meals=int((comp_price - our_prices[1]) / 15),
                movies=int((comp_price - our_prices[1]) / 35),
                coffees=int((comp_price - our_prices[1]) / 12),
            ),
        },
        {
            "style": "品质证明型",
            "text": (
                "🤔 「便宜没好货？」{product}用事实说话！\n\n"
                "💰 价格对比:\n"
                "  品牌专柜: ¥{comp}\n"
                "  我们:     ¥{our}\n\n"
                "🔬 品质对比:\n"
                "  ✅ 同厂同线生产\n"
                "  ✅ 相同原材料\n"
                "  ✅ 相同工艺标准\n"
                "  ✅ 相同质检流程\n\n"
                "唯一的区别？我们没有品牌溢价！\n\n"
                "📋 我们敢承诺:\n"
                "  · 7天无理由退换\n"
                "  · 假一赔十\n"
                "  · 运费险保障\n\n"
                "低价≠低质，工厂直供就是这么有底气！"
            ).format(product=product, comp=comp_price, our=our_prices[1]),
        },
    ]

    for i, t in enumerate(templates):
        print("方案{} [{}]:".format(i + 1, t["style"]))
        print(t["text"])
        print("")
        print("-" * 50)
        print("")

    print("💡 价格对比文案技巧:")
    print("  - 用具体数字说话，避免模糊对比")
    print("  - 解释低价原因，消除「便宜没好货」顾虑")
    print("  - 把省下的钱换算成具体场景更有冲击力")
    print("  - 注意不要直接点名竞品品牌（法律风险）")

def gen_price_war(product, competitor_price):
    print("=" * 60)
    print("  拼多多价格战策略 - {}".format(product))
    print("  竞品价格: ¥{}".format(competitor_price))
    print("=" * 60)
    print("")

    try:
        comp = float(competitor_price)
    except (ValueError, TypeError):
        comp = 100.0

    # 定价策略
    print("💰 【定价策略分析】")
    print("")
    strategies = [
        {
            "name": "低价引流款",
            "price": round(comp * 0.35, 1),
            "desc": "亏本引流，靠其他SKU盈利",
            "margin": "-15%~-5%",
            "scene": "新店开业/冲销量/抢坑位",
        },
        {
            "name": "平价走量款",
            "price": round(comp * 0.50, 1),
            "desc": "微利走量，快速积累销量和评价",
            "margin": "5%~15%",
            "scene": "日常主推/百亿补贴申报",
        },
        {
            "name": "性价比主推款",
            "price": round(comp * 0.65, 1),
            "desc": "合理利润，主力盈利款",
            "margin": "20%~35%",
            "scene": "店铺利润担当/品质款",
        },
        {
            "name": "品质溢价款",
            "price": round(comp * 0.80, 1),
            "desc": "品质升级，赚取品牌溢价",
            "margin": "35%~50%",
            "scene": "品牌旗舰/礼盒装/组合装",
        },
    ]
    for s in strategies:
        print("  📊 {} | 建议价: ¥{} | 利润率: {}".format(s["name"], s["price"], s["margin"]))
        print("     策略: {} | 适用: {}".format(s["desc"], s["scene"]))
        print("")

    # 凑单满减设计
    print("🎫 【凑单满减设计】")
    print("")
    base_price = round(comp * 0.50, 0)
    tiers = [
        {"threshold": int(base_price * 2 + 1), "discount": int(base_price * 0.15)},
        {"threshold": int(base_price * 3 + 1), "discount": int(base_price * 0.35)},
        {"threshold": int(base_price * 5 + 1), "discount": int(base_price * 0.65)},
    ]
    print("  基于主推价 ¥{:.0f} 的满减梯度:".format(base_price))
    print("")
    for t in tiers:
        print("  🔸 满{}减{} → 客单价提升至¥{}+，利润增加约¥{}".format(
            t["threshold"], t["discount"], t["threshold"],
            int(t["threshold"] * 0.15)))
    print("")
    print("  📋 凑单引导文案:")
    print("  · 「再凑¥XX即可享满减优惠！推荐搭配→」")
    print("  · 「买2件更划算！第2件立减¥XX！」")
    print("  · 「凑单神器！小件好物，满减凑单首选」")
    print("")

    # SKU定价矩阵
    print("📐 【SKU定价矩阵】")
    print("")
    print("  建议设置3-5个SKU，形成价格梯度:")
    print("")
    sku_matrix = [
        {"name": "基础款/体验装", "price": round(comp * 0.30, 1), "purpose": "拉低起售价，吸引点击"},
        {"name": "标准款/热销装", "price": round(comp * 0.50, 1), "purpose": "主力销售款，性价比最高"},
        {"name": "升级款/家庭装", "price": round(comp * 0.65, 1), "purpose": "提升客单价，利润贡献"},
        {"name": "豪华款/礼盒装", "price": round(comp * 0.85, 1), "purpose": "品质形象款，高利润"},
    ]
    for sku in sku_matrix:
        print("  ├ {} → ¥{} | {}".format(sku["name"], sku["price"], sku["purpose"]))
    print("")

    # 竞争应对
    print("⚔️ 【竞品应对策略】")
    print("")
    print("  当竞品降价时:")
    print("  ✅ 不盲目跟价，先分析竞品是否可持续")
    print("  ✅ 用赠品/组合装替代直接降价")
    print("  ✅ 突出差异化卖点（材质/工艺/售后）")
    print("  ✅ 申请百亿补贴/限时秒杀获取流量")
    print("")
    print("  当竞品涨价时:")
    print("  ✅ 保持现价，突出性价比优势")
    print("  ✅ 适当提价但幅度小于竞品")
    print("  ✅ 加大推广投入，抢占竞品流量")
    print("")

    print("-" * 60)
    print("💡 拼多多定价技巧:")
    print("  - 起售价（最低SKU）决定搜索排名展示价")
    print("  - 设置「凑单专区」帮买家凑满减")
    print("  - 活动报名要求最低价，日常可略高")
    print("  - 多多进宝佣金设置10-30%获取更多推手流量")


def gen_review_reply(review_type):
    print("=" * 60)
    print("  拼多多评价回复模板 - {}".format(review_type))
    print("=" * 60)
    print("")

    rt = review_type.lower().replace(" ", "")

    if "好评" in rt or "好" in rt or "positive" in rt:
        print("👍 【好评感谢回复】（5套模板）")
        print("")
        templates = [
            "亲，感谢您的认可和好评！能得到您的肯定是我们最大的动力～我们家还有很多好物，欢迎常来逛逛！有任何需要随时联系我们哦，祝您生活愉快！❤️",
            "谢谢亲的五星好评！看到您满意我们太开心了！下次购买记得找客服领专属老客优惠券哦～期待您的再次光临！😊",
            "亲爱的，非常感谢您的好评！您的支持是我们坚持做好产品的动力！已经为您备注VIP老客身份，下次下单享专属折扣！🌟",
            "哇，收到好评好开心！感谢亲的认可～我们会继续保持品质，不辜负每一位客户的信任。记得收藏店铺，新品上架第一时间通知您！💕",
            "亲，您的好评让我们整个团队都备受鼓舞！每一份认可都是我们前进的动力。欢迎推荐给身边的朋友，好东西值得分享！🎉",
        ]
        for i, t in enumerate(templates, 1):
            print("  回复{}: {}".format(i, t))
            print("")

        print("  📌 好评回复加分项:")
        print("    · 提及老客优惠，引导复购")
        print("    · 邀请收藏店铺，增加粉丝")
        print("    · 鼓励分享推荐，获取新客")
        print("    · 根据评价内容个性化回复（别复制粘贴）")

    elif "差评" in rt or "差" in rt or "negative" in rt:
        print("⚠️ 【差评化解回复】（5套模板）")
        print("")
        templates = [
            "亲，非常抱歉给您带来不好的体验！您的问题我们已经记录并会认真改进。为了弥补您的损失，请您联系在线客服（工作时间9:00-22:00），我们会为您提供满意的解决方案，绝对让您不白花这份钱！🙏",
            "亲爱的，看到您的评价我们非常心痛和自责。这不是我们产品应有的表现，我们深表歉意！请您私聊客服，我们承诺：① 全额退款 ② 补发新品 ③ 额外补偿，您选一个最方便的方案！💪",
            "亲，首先真诚向您道歉！您反馈的问题我们高度重视，已经安排品控部门紧急排查。为了不耽误您的时间，请联系客服，我们5分钟内响应，一定给您一个满意的交代！❤️",
            "非常对不起亲！您的体验是我们的失职。我们不找借口，只想尽快帮您解决问题。请联系客服说「差评处理」，我们有专人对接，优先为您处理，不让您多等一分钟！",
            "亲，这条差评我们全组都看了，非常惭愧。我们已经针对您提到的问题制定了整改方案。现在最重要的是帮您解决问题——请联系客服，退款/换货/补偿任您选择，我们诚意满满！🙏",
        ]
        for i, t in enumerate(templates, 1):
            print("  回复{}: {}".format(i, t))
            print("")

        print("  📌 差评化解要点:")
        print("    · 先道歉，不解释不辩解")
        print("    · 给出明确解决方案（退/换/补）")
        print("    · 引导私聊，避免公开争论")
        print("    · 处理完毕后礼貌请求修改评价")
        print("    · 24小时内回复，体现重视")

    elif "追评" in rt or "追" in rt or "followup" in rt:
        print("🔄 【追评引导话术】")
        print("")
        print("  📌 主动引导追评（下单后7-15天发送）:")
        print("")
        templates = [
            "亲，您好！您购买的宝贝用了有一段时间了，使用感受还满意吗？如果方便的话，希望您能追评分享一下使用体验，帮助更多买家做参考。追评后联系客服领取5元无门槛优惠券哦～ 感谢支持！❤️",
            "Hi亲～ 还记得前几天买的宝贝吗？用得怎么样呀？如果觉得不错，麻烦花1分钟追评一下，写上真实感受就好。追评晒图还能领取精美小礼品，感谢您！😊",
            "亲爱的，您的使用体验对其他买家很重要！如果宝贝用着满意，希望您能追评告诉大家。我们为追评用户准备了专属福利：① 5元返现 ② 下次购买9折 ③ 新品试用资格。任选其一！🎁",
        ]
        for i, t in enumerate(templates, 1):
            print("  方案{}: {}".format(i, t))
            print("")

        print("  📌 追评引导时机:")
        print("    · 确认收货后3天：产品初体验")
        print("    · 使用7-15天后：深度体验反馈")
        print("    · 节日/大促前：积累评价为活动蓄力")
        print("")
        print("  📌 追评激励方式:")
        print("    · 追评返现（2-5元红包）")
        print("    · 追评送券（下次购买可用）")
        print("    · 晒图追评额外奖励")
        print("    · 视频追评最高奖励")

    else:
        # 通用模板——按类型混合输出
        print("📋 【评价回复通用模板库】")
        print("")
        print("  类型: {}".format(review_type))
        print("  提示: 使用 review-reply \"好评/差评/追评\" 获取专项模板")
        print("")
        print("  通用好评回复: 亲，感谢您的认可！您的满意就是我们最大的动力～❤️")
        print("  通用差评回复: 亲，非常抱歉！请联系客服，我们一定给您满意的解决方案！🙏")
        print("  通用追评引导: 亲，用了一段时间感觉如何？期待您的追评分享～🎁")

    print("")
    print("-" * 60)
    print("💡 评价管理技巧:")
    print("  - 好评要及时感谢，坏评要24小时内处理")
    print("  - 不要用千篇一律的回复，尽量个性化")
    print("  - 差评处理后请求修改，态度比补偿更重要")
    print("  - 定期分析评价关键词，改进产品和服务")


def gen_seckill(product):
    print("=" * 60)
    print("  拼多多秒杀/限时购文案 - {}".format(product))
    print("=" * 60)
    print("")

    # 秒杀标题
    print("⚡ 【秒杀标题】（5套方案）")
    print("")
    titles = [
        "【限时秒杀】{} 全网底价！XX点开抢，手慢无！".format(product),
        "【闪电特惠】{} 直降XX元！限量XXX件，抢完即止！".format(product),
        "【限时抢购】{} 1元起抢！每天10点/20点准时开抢！".format(product),
        "【今日特价】{} 工厂清仓价！最后XXX件，卖完恢复原价！".format(product),
        "【秒杀预告】{} 明天XX点开抢！先领券再抢更划算！".format(product),
    ]
    for i, t in enumerate(titles, 1):
        print("  {}. {}".format(i, t))
    print("")

    # 秒杀详情文案
    print("📝 【秒杀详情页文案】")
    print("")
    print("  ┌──────────────────────────────────────┐")
    print("  │  ⚡ 限时秒杀 · {} │".format(product))
    print("  │                                      │")
    print("  │  💰 秒杀价: ¥XX（原价¥XX）           │")
    print("  │  ⏰ 活动时间: XX:00 - XX:00           │")
    print("  │  📦 限量: XXX件                       │")
    print("  │  🔥 已抢: XX%                         │")
    print("  │                                      │")
    print("  │  ✅ 正品保障  ✅ 极速发货              │")
    print("  │  ✅ 7天无理由 ✅ 运费险                │")
    print("  └──────────────────────────────────────┘")
    print("")

    # 秒杀倒计时话术
    print("⏰ 【秒杀倒计时文案】")
    print("")
    countdown = [
        {"time": "开抢前1小时", "text": "距离{}秒杀开始还有1小时！先加购物车，到点直接抢！".format(product)},
        {"time": "开抢前10分钟", "text": "倒计时10分钟！{}秒杀马上开始！打开拼多多等着抢！".format(product)},
        {"time": "开抢前1分钟", "text": "最后60秒！{}秒杀即将开抢！手指放在按钮上！".format(product)},
        {"time": "开抢中", "text": "开抢了！{}秒杀进行中！库存剩XX件，手速决定一切！".format(product)},
        {"time": "库存告急", "text": "最后XX件！{}秒杀即将售罄！犹豫=错过！赶紧下单！".format(product)},
    ]
    for c in countdown:
        print("  ⏱ [{}] {}".format(c["time"], c["text"]))
    print("")

    # 秒杀朋友圈/群分享文案
    print("📣 【分享引流文案】（发群/朋友圈）")
    print("")
    shares = [
        "🔥 拼多多秒杀预告！{}只要¥XX！限量XXX件！XX点准时开抢→ [链接]".format(product),
        "⚡ 天呐！{}居然只要¥XX！秒杀价比日常便宜一半！快去抢→ [链接]".format(product),
        "刚抢到一个{}，秒杀价¥XX！还有库存，手速快的冲→ [链接]".format(product),
        "帮你们踩过雷了！这个{}是真的好用，现在秒杀才¥XX，闭眼入→ [链接]".format(product),
    ]
    for i, s in enumerate(shares, 1):
        print("  {}. {}".format(i, s))
    print("")

    # 秒杀运营建议
    print("📋 【秒杀运营节奏】")
    print("")
    print("  开抢前48小时:  提交秒杀报名，准备好库存")
    print("  开抢前24小时:  社群+朋友圈预热，发预告文案")
    print("  开抢前2小时:   再次提醒，引导加购物车")
    print("  开抢时:        实时播报库存，制造紧张感")
    print("  售罄后:        发「售罄」截图，为下次秒杀预热")
    print("  结束后:        引导买家评价，积累口碑")
    print("")

    print("-" * 60)
    print("💡 秒杀技巧:")
    print("  - 秒杀价建议是日常价的50-70%，冲击力才够")
    print("  - 库存不宜过多，制造稀缺感（100-500件最佳）")
    print("  - 选择10:00/14:00/20:00等流量高峰时段")
    print("  - 提前在社群/朋友圈预热，秒杀效果翻倍")
    print("  - 秒杀款要关联推荐利润款，提升整体收益")


def main():
    args = sys.argv[1:]
    if not args:
        show_help()
        return

    cmd = args[0]

    if cmd == "help":
        show_help()
    elif cmd == "title":
        if len(args) < 3:
            print("用法: pdd.sh title \"产品名\" \"关键词1,关键词2\"")
            sys.exit(1)
        gen_title(args[1], args[2])
    elif cmd == "desc":
        if len(args) < 2:
            print("用法: pdd.sh desc \"产品名\"")
            sys.exit(1)
        gen_desc(args[1])
    elif cmd == "group":
        if len(args) < 3:
            print("用法: pdd.sh group \"产品名\" \"价格\"")
            sys.exit(1)
        gen_group(args[1], args[2])
    elif cmd == "compare":
        if len(args) < 3:
            print("用法: pdd.sh compare \"产品名\" \"竞品价格\"")
            sys.exit(1)
        gen_compare(args[1], args[2])
    elif cmd == "price-war":
        if len(args) < 3:
            print("用法: pdd.sh price-war \"产品名\" \"竞品价格\"")
            sys.exit(1)
        gen_price_war(args[1], args[2])
    elif cmd == "review-reply":
        if len(args) < 2:
            print("用法: pdd.sh review-reply \"好评/差评/追评\"")
            sys.exit(1)
        gen_review_reply(args[1])
    elif cmd == "seckill":
        if len(args) < 2:
            print("用法: pdd.sh seckill \"产品名\"")
            sys.exit(1)
        gen_seckill(args[1])
    else:
        print("未知命令: {}".format(cmd))
        print("运行 pdd.sh help 查看帮助")
        sys.exit(1)

if __name__ == "__main__":
    main()
PYTHON_EOF

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
