---
version: "2.0.0"
name: wp-manager
description: "WordPress site manager via REST API. WordPress博客管理、WordPress网站管理、WP建站、文章发布、页面管理、博客发布、媒体上传、图片管理、插件管理、主题设置、SEO优化、搜索引擎优化、SEO检查、网站安全、安全加固、速度优化、备份策略、内容管理系统CMS、网站运维、站点管理、博客运营。Manage posts, pages, media, plugins, themes, templates, and site settings. SEO health check, security audit, speed optimization, backup strategy. Blog management, content publishing, website operations. Use when: (1) managing WordPress sites/blogs, (2) publishing or editing posts and pages, (3) uploading media files, (4) managing plugins and themes, (5) updating site settings and SEO, (6) WordPress REST API operations, (7) checking SEO score, (8) WordPress security hardening, (9) site speed optimization, (10) backup planning. 适用场景：发布文章、管理页面、上传图片、管理插件主题、修改网站设置、WordPress自动化运维、SEO检查、安全加固、速度优化、备份策略。 Triggers on: wp manager."
author: BytesAgain
---

# WP Manager

Manage WordPress sites via REST API. Cookie-based auth, no plugins required.

## 为什么用这个 Skill？ / Why This Skill?

- **结构化命令** vs 直接问AI：预置了完整的WordPress REST API调用链，登录→鉴权→操作一步到位，不用手写curl
- **Cookie认证**：自动处理登录、cookie存储、nonce提取，不需要安装额外插件
- **Block格式**：自动生成WordPress Gutenberg block标记，不用手写HTML
- Compared to asking AI directly: this skill provides ready-to-run shell commands that handle auth, nonce, and WordPress block formatting automatically

## Setup

Store credentials in `.env`:
```
WP_URL=https://example.com
WP_USER=admin
WP_PASS=yourpassword
```

## Quick Start

```bash
# Load env
source .env

# Login + get auth cookie & nonce
scripts/wp.sh login

# Then use any command:
scripts/wp.sh posts          # List recent posts
scripts/wp.sh publish "Title" "Content here"   # Create post
scripts/wp.sh pages          # List pages
scripts/wp.sh plugins        # List plugins
scripts/wp.sh media upload ./image.png          # Upload media
scripts/wp.sh settings       # View site settings
```

## Commands

### Content
```bash
wp.sh posts                          # List recent posts
wp.sh post <id>                      # Get single post
wp.sh publish "Title" "Content"      # Publish new post
wp.sh draft "Title" "Content"        # Save as draft
wp.sh edit <id> "New content"        # Update post content
wp.sh delete <id>                    # Trash a post
wp.sh pages                          # List pages
wp.sh page-publish "Title" "Content" # Publish new page
```

### Media
```bash
wp.sh media                          # List media
wp.sh media upload ./file.png        # Upload file
```

### Plugins
```bash
wp.sh plugins                        # List all plugins
wp.sh plugin-activate <slug>         # Activate plugin
wp.sh plugin-deactivate <slug>       # Deactivate plugin
wp.sh plugin-delete <slug>           # Delete plugin
```

### Site Settings
```bash
wp.sh settings                       # View settings
wp.sh set-title "New Title"          # Update site title
wp.sh set-tagline "New tagline"      # Update tagline
wp.sh set-homepage posts             # Set homepage to latest posts
wp.sh set-homepage page <id>         # Set static homepage
```

### Templates (Block Themes)
```bash
wp.sh templates                      # List templates
wp.sh template <id>                  # Get template content
wp.sh template-update <id> "content" # Update template
wp.sh template-parts                 # List template parts
wp.sh template-part <id>             # Get template part
wp.sh template-part-update <id> "content"  # Update template part
```

### SEO & Operations
```bash
wp.sh seo-check "URL"                # SEO health check (16 items)
wp.sh security                       # WordPress security checklist
wp.sh speed                          # Site speed optimization guide
wp.sh backup                         # Backup strategy + script template
```

See also: `tips.md` for WordPress best practices.

## Auth Notes

- Uses `curl --data-urlencode` for login (handles special chars in passwords)
- Cookie stored in `/tmp/wp-session.txt`
- Nonce extracted from `/wp-admin/post-new.php`
- Sessions expire ~24-48h; re-run `wp.sh login` if you get 401/403
- REST API base: `{WP_URL}/wp-json/wp/v2/`

## Content Format

Post/page content uses WordPress block markup:
```html
<!-- wp:paragraph -->
<p>Your text here</p>
<!-- /wp:paragraph -->

<!-- wp:heading -->
<h2>Section Title</h2>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><li>Item 1</li><li>Item 2</li></ul>
<!-- /wp:list -->
```

Plain HTML also works — WordPress auto-wraps in classic blocks.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
