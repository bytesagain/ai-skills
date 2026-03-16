#!/usr/bin/env bash
# wechat-mini-app — 微信小程序开发工具
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
run_python() {
python3 << 'PYEOF'
import sys, json
from datetime import datetime

cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

def cmd_init():
    if not inp:
        print("Usage: init <project_name> [type]")
        print("Types: ecommerce, content, tool, social")
        return
    parts = inp.split()
    name = parts[0]
    ptype = parts[1] if len(parts) > 1 else "tool"

    pages = {
        "ecommerce": ["index","category","product","cart","order","user"],
        "content": ["index","list","detail","search","user"],
        "tool": ["index","result","history","settings"],
        "social": ["index","feed","chat","profile","settings"],
    }
    pg = pages.get(ptype, pages["tool"])

    print("// app.json")
    config = {
        "pages": ["pages/{}/{}".format(p,p) for p in pg],
        "window": {
            "navigationBarBackgroundColor": "#ffffff",
            "navigationBarTitleText": name,
            "navigationBarTextStyle": "black",
            "backgroundColor": "#f5f5f5"
        },
        "tabBar": {
            "list": [
                {"pagePath": "pages/{}/{}".format(pg[0],pg[0]), "text": "Home", "iconPath": "images/home.png", "selectedIconPath": "images/home-active.png"},
                {"pagePath": "pages/{}/{}".format(pg[-1],pg[-1]), "text": "Me", "iconPath": "images/user.png", "selectedIconPath": "images/user-active.png"},
            ]
        },
        "sitemapLocation": "sitemap.json"
    }
    print(json.dumps(config, indent=2, ensure_ascii=False))
    print("")
    print("// Project structure:")
    print("  {}/".format(name))
    for p in pg:
        print("    pages/{}/".format(p))
        print("      {}.js".format(p))
        print("      {}.json".format(p))
        print("      {}.wxml".format(p))
        print("      {}.wxss".format(p))
    print("    images/")
    print("    utils/")
    print("      util.js")
    print("    app.js")
    print("    app.json")
    print("    app.wxss")

def cmd_page():
    if not inp:
        print("Usage: page <page_name> [type]")
        print("Types: list, detail, form, grid, blank")
        return
    parts = inp.split()
    name = parts[0]
    ptype = parts[1] if len(parts) > 1 else "blank"

    # WXML
    templates = {
        "list": '<view class="container">\n  <view class="search-bar">\n    <input placeholder="Search..." bindinput="onSearch" />\n  </view>\n  <scroll-view scroll-y class="list">\n    <block wx:for="{{items}}" wx:key="id">\n      <view class="list-item" bindtap="onItemTap" data-id="{{item.id}}">\n        <image src="{{item.image}}" mode="aspectFill" />\n        <view class="item-info">\n          <text class="title">{{item.title}}</text>\n          <text class="desc">{{item.desc}}</text>\n        </view>\n      </view>\n    </block>\n  </scroll-view>\n</view>',
        "detail": '<view class="container">\n  <image src="{{detail.image}}" mode="widthFix" class="banner" />\n  <view class="content">\n    <text class="title">{{detail.title}}</text>\n    <text class="desc">{{detail.description}}</text>\n  </view>\n  <view class="action-bar">\n    <button type="primary" bindtap="onAction">Action</button>\n  </view>\n</view>',
        "form": '<view class="container">\n  <form bindsubmit="onSubmit">\n    <view class="form-group">\n      <text>Name</text>\n      <input name="name" placeholder="Enter name" />\n    </view>\n    <view class="form-group">\n      <text>Email</text>\n      <input name="email" type="text" placeholder="Email" />\n    </view>\n    <view class="form-group">\n      <text>Notes</text>\n      <textarea name="notes" placeholder="Notes..." />\n    </view>\n    <button form-type="submit" type="primary">Submit</button>\n  </form>\n</view>',
        "grid": '<view class="container">\n  <view class="grid">\n    <block wx:for="{{items}}" wx:key="id">\n      <view class="grid-item" bindtap="onItemTap" data-id="{{item.id}}">\n        <image src="{{item.icon}}" />\n        <text>{{item.name}}</text>\n      </view>\n    </block>\n  </view>\n</view>',
        "blank": '<view class="container">\n  <text>{{message}}</text>\n</view>',
    }

    wxml = templates.get(ptype, templates["blank"])

    print("// pages/{}/{}.wxml".format(name, name))
    print(wxml)
    print("")

    # JS
    print("// pages/{}/{}.js".format(name, name))
    print("Page({")
    print("  data: {")
    if ptype == "list":
        print("    items: [],")
        print("    searchKey: ''")
    elif ptype == "detail":
        print("    detail: {}")
    elif ptype == "form":
        print("    formData: {}")
    elif ptype == "grid":
        print("    items: []")
    else:
        print("    message: 'Hello'")
    print("  },")
    print("  onLoad(options) {")
    print("    // Init")
    print("  },")
    if ptype == "list":
        print("  onSearch(e) {")
        print("    this.setData({ searchKey: e.detail.value });")
        print("  },")
        print("  onItemTap(e) {")
        print("    const id = e.currentTarget.dataset.id;")
        print("    wx.navigateTo({ url: '/pages/detail/detail?id=' + id });")
        print("  },")
    elif ptype == "form":
        print("  onSubmit(e) {")
        print("    console.log(e.detail.value);")
        print("    wx.showToast({ title: 'Submitted' });")
        print("  },")
    print("});")
    print("")

    # WXSS
    print("// pages/{}/{}.wxss".format(name, name))
    print(".container { padding: 20rpx; }")
    if ptype == "list":
        print(".list-item { display: flex; padding: 20rpx; border-bottom: 1rpx solid #eee; }")
        print(".list-item image { width: 120rpx; height: 120rpx; border-radius: 8rpx; }")
        print(".item-info { flex: 1; margin-left: 20rpx; }")
        print(".title { font-size: 30rpx; font-weight: bold; }")
        print(".desc { font-size: 24rpx; color: #888; margin-top: 8rpx; }")
    elif ptype == "grid":
        print(".grid { display: flex; flex-wrap: wrap; }")
        print(".grid-item { width: 25%; text-align: center; padding: 20rpx 0; }")
        print(".grid-item image { width: 80rpx; height: 80rpx; }")

def cmd_api():
    if not inp:
        print("Usage: api <api_name>")
        print("APIs: request, login, pay, share, storage, location, scan")
        return

    apis = {
        "request": """// HTTP Request
wx.request({
  url: 'https://api.example.com/data',
  method: 'GET',
  header: { 'Authorization': 'Bearer ' + token },
  success(res) { console.log(res.data); },
  fail(err) { console.error(err); }
});""",
        "login": """// WeChat Login Flow
wx.login({
  success(res) {
    if (res.code) {
      // Send code to your server
      wx.request({
        url: 'https://api.example.com/login',
        method: 'POST',
        data: { code: res.code },
        success(result) {
          wx.setStorageSync('token', result.data.token);
        }
      });
    }
  }
});""",
        "pay": """// WeChat Pay
wx.requestPayment({
  timeStamp: payData.timeStamp,
  nonceStr: payData.nonceStr,
  package: payData.package,
  signType: 'RSA',
  paySign: payData.paySign,
  success(res) { wx.showToast({ title: 'Paid' }); },
  fail(err) { wx.showToast({ title: 'Cancelled', icon: 'none' }); }
});""",
        "share": """// Share to Chat
Page({
  onShareAppMessage() {
    return {
      title: 'Check this out!',
      path: '/pages/index/index?shared=true',
      imageUrl: '/images/share.png'
    };
  }
});""",
        "storage": """// Local Storage
// Save
wx.setStorageSync('key', { data: 'value', time: Date.now() });
// Read
const data = wx.getStorageSync('key');
// Remove
wx.removeStorageSync('key');
// Clear all
wx.clearStorageSync();""",
        "location": """// Get Location
wx.getLocation({
  type: 'gcj02',
  success(res) {
    console.log('Lat:', res.latitude, 'Lng:', res.longitude);
  }
});""",
        "scan": """// QR Code Scan
wx.scanCode({
  onlyFromCamera: false,
  scanType: ['qrCode', 'barCode'],
  success(res) {
    console.log('Result:', res.result);
  }
});""",
    }

    api = inp.strip().lower()
    if api in apis:
        print(apis[api])
    else:
        print("Available APIs: {}".format(", ".join(apis.keys())))

def cmd_review():
    print("=" * 55)
    print("  微信小程序审核清单")
    print("=" * 55)
    print("")
    checks = [
        "基础检查",
        ["[ ] 小程序名称合规（不含特殊符号）",
         "[ ] 小程序简介准确描述功能",
         "[ ] 类目选择正确",
         "[ ] 服务条款和隐私政策页面"],
        "功能检查",
        ["[ ] 所有页面可正常访问",
         "[ ] 表单有输入验证",
         "[ ] 网络请求有loading和错误处理",
         "[ ] 授权拒绝后有替代方案"],
        "体验检查",
        ["[ ] 首屏加载<3秒",
         "[ ] 页面无空白或报错",
         "[ ] 返回按钮正常工作",
         "[ ] 不同机型适配正常"],
        "合规检查",
        ["[ ] 不强制授权登录",
         "[ ] 不诱导分享",
         "[ ] 无虚假宣传",
         "[ ] 用户数据处理合规"],
    ]
    for i in range(0, len(checks), 2):
        print("  {}:".format(checks[i]))
        for c in checks[i+1]:
            print("    {}".format(c))
        print("")

commands = {
    "init": cmd_init, "page": cmd_page,
    "api": cmd_api, "review": cmd_review,
}
if cmd == "help":
    print("WeChat Mini App Developer Tool")
    print("")
    print("Commands:")
    print("  init <name> [type]     — Generate project scaffold")
    print("  page <name> [type]     — Generate page template (list/detail/form/grid)")
    print("  api <api_name>         — API code snippets (request/login/pay/share/...)")
    print("  review                 — Pre-submission review checklist")
    print("")
    print("Project types: ecommerce, content, tool, social")
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown: {}".format(cmd))
print("")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
}
run_python "$CMD" $INPUT
