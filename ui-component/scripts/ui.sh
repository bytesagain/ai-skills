#!/usr/bin/env bash
# ui-component — HTML/CSS组件生成器
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"

# Parse flags
STYLE="vanilla"
for arg in $INPUT; do
  case "$arg" in
    --tailwind) STYLE="tailwind" ;;
    --bootstrap) STYLE="bootstrap" ;;
    --vanilla) STYLE="vanilla" ;;
  esac
done

show_help() {
cat << 'EOF'
🎨 UI Component Generator

Commands:
  button [--tailwind|--bootstrap]  — Button components
  card [--tailwind|--bootstrap]    — Card components
  navbar [--tailwind|--bootstrap]  — Navigation bar
  modal [--tailwind|--bootstrap]   — Modal/dialog
  form [--tailwind|--bootstrap]    — Form components
  table [--tailwind|--bootstrap]   — Data table
  hero [--tailwind|--bootstrap]    — Hero section
  footer [--tailwind|--bootstrap]  — Footer section
  grid [--tailwind|--bootstrap]    — Grid layout
  alert [--tailwind|--bootstrap]   — Alert/notification
  help                             — Show this help
EOF
}

cmd_button() {
case "$STYLE" in
tailwind) cat << 'EOF'
<!-- Tailwind CSS Buttons -->
<button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
  Primary
</button>
<button class="bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white py-2 px-4 border border-blue-500 hover:border-transparent rounded">
  Outline
</button>
<button class="bg-gray-300 text-gray-500 font-bold py-2 px-4 rounded cursor-not-allowed" disabled>
  Disabled
</button>
<button class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-full">
  Danger Pill
</button>
<button class="bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-6 rounded-lg shadow-lg transform hover:scale-105 transition">
  Success with Animation
</button>
<button class="group relative bg-gradient-to-r from-purple-500 to-pink-500 text-white font-bold py-3 px-6 rounded-lg">
  <span class="group-hover:opacity-0 transition">Hover Me</span>
  <span class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition">✨ Magic!</span>
</button>
EOF
;;
bootstrap) cat << 'EOF'
<!-- Bootstrap Buttons -->
<button type="button" class="btn btn-primary">Primary</button>
<button type="button" class="btn btn-outline-secondary">Outline</button>
<button type="button" class="btn btn-danger btn-lg">Large Danger</button>
<button type="button" class="btn btn-success btn-sm">Small Success</button>
<button type="button" class="btn btn-warning rounded-pill px-4">Warning Pill</button>
<button type="button" class="btn btn-dark" disabled>Disabled</button>
<div class="btn-group" role="group">
  <button type="button" class="btn btn-primary">Left</button>
  <button type="button" class="btn btn-primary">Middle</button>
  <button type="button" class="btn btn-primary">Right</button>
</div>
EOF
;;
*) cat << 'EOF'
<!-- Vanilla CSS Buttons -->
<style>
.btn { padding: 10px 20px; border: none; border-radius: 6px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
.btn-primary { background: #3b82f6; color: white; }
.btn-primary:hover { background: #2563eb; transform: translateY(-1px); box-shadow: 0 4px 12px rgba(59,130,246,0.4); }
.btn-outline { background: transparent; color: #3b82f6; border: 2px solid #3b82f6; }
.btn-outline:hover { background: #3b82f6; color: white; }
.btn-danger { background: #ef4444; color: white; }
.btn-danger:hover { background: #dc2626; }
.btn-ghost { background: transparent; color: #6b7280; }
.btn-ghost:hover { background: #f3f4f6; }
.btn:disabled { opacity: 0.5; cursor: not-allowed; }
.btn-group { display: inline-flex; }
.btn-group .btn { border-radius: 0; }
.btn-group .btn:first-child { border-radius: 6px 0 0 6px; }
.btn-group .btn:last-child { border-radius: 0 6px 6px 0; }
</style>
<button class="btn btn-primary">Primary</button>
<button class="btn btn-outline">Outline</button>
<button class="btn btn-danger">Danger</button>
<button class="btn btn-ghost">Ghost</button>
<button class="btn btn-primary" disabled>Disabled</button>
<div class="btn-group">
  <button class="btn btn-primary">Left</button>
  <button class="btn btn-primary">Mid</button>
  <button class="btn btn-primary">Right</button>
</div>
EOF
;;
esac
}

cmd_card() {
case "$STYLE" in
tailwind) cat << 'EOF'
<!-- Tailwind Card -->
<div class="max-w-sm rounded-xl overflow-hidden shadow-lg bg-white">
  <img class="w-full h-48 object-cover" src="https://via.placeholder.com/400x200" alt="Cover">
  <div class="px-6 py-4">
    <h3 class="font-bold text-xl mb-2 text-gray-800">Card Title</h3>
    <p class="text-gray-600 text-base">Card description goes here with some details.</p>
  </div>
  <div class="px-6 pt-2 pb-4">
    <span class="inline-block bg-blue-100 text-blue-800 rounded-full px-3 py-1 text-sm font-semibold mr-2">#tag1</span>
    <span class="inline-block bg-green-100 text-green-800 rounded-full px-3 py-1 text-sm font-semibold">#tag2</span>
  </div>
</div>
EOF
;;
*) cat << 'EOF'
<!-- Vanilla CSS Card -->
<style>
.card { max-width: 380px; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 24px rgba(0,0,0,0.1); background: white; transition: transform 0.2s; }
.card:hover { transform: translateY(-4px); box-shadow: 0 8px 32px rgba(0,0,0,0.15); }
.card img { width: 100%; height: 200px; object-fit: cover; }
.card-body { padding: 20px; }
.card-body h3 { margin: 0 0 8px; font-size: 20px; color: #1f2937; }
.card-body p { margin: 0 0 16px; color: #6b7280; line-height: 1.5; }
.card-tags { padding: 0 20px 20px; }
.tag { display: inline-block; padding: 4px 12px; border-radius: 999px; font-size: 13px; font-weight: 600; margin-right: 8px; }
.tag-blue { background: #dbeafe; color: #1d4ed8; }
.tag-green { background: #dcfce7; color: #166534; }
</style>
<div class="card">
  <img src="https://via.placeholder.com/400x200" alt="Cover">
  <div class="card-body">
    <h3>Card Title</h3>
    <p>Card description with details about the content.</p>
  </div>
  <div class="card-tags">
    <span class="tag tag-blue">#design</span>
    <span class="tag tag-green">#ui</span>
  </div>
</div>
EOF
;;
esac
}

cmd_navbar() {
cat << 'EOF'
<!-- Responsive Navigation Bar -->
<style>
.navbar { display: flex; align-items: center; justify-content: space-between; padding: 0 24px; height: 64px; background: #1f2937; color: white; }
.navbar-brand { font-size: 20px; font-weight: 700; text-decoration: none; color: white; }
.navbar-links { display: flex; gap: 24px; list-style: none; margin: 0; padding: 0; }
.navbar-links a { color: #d1d5db; text-decoration: none; font-size: 14px; transition: color 0.2s; }
.navbar-links a:hover { color: white; }
.navbar-cta { padding: 8px 16px; background: #3b82f6; color: white; border: none; border-radius: 6px; cursor: pointer; }
@media(max-width:768px) { .navbar-links { display: none; } }
</style>
<nav class="navbar">
  <a href="#" class="navbar-brand">Brand</a>
  <ul class="navbar-links">
    <li><a href="#">Home</a></li>
    <li><a href="#">Features</a></li>
    <li><a href="#">Pricing</a></li>
    <li><a href="#">About</a></li>
  </ul>
  <button class="navbar-cta">Get Started</button>
</nav>
EOF
}

cmd_modal() {
cat << 'EOF'
<!-- Modal / Dialog -->
<style>
.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal { background: white; border-radius: 12px; padding: 32px; max-width: 480px; width: 90%; box-shadow: 0 20px 60px rgba(0,0,0,0.3); animation: modalIn 0.3s; }
@keyframes modalIn { from { opacity:0; transform:scale(0.95); } to { opacity:1; transform:scale(1); } }
.modal h2 { margin: 0 0 8px; font-size: 22px; }
.modal p { color: #6b7280; margin: 0 0 24px; }
.modal-actions { display: flex; gap: 12px; justify-content: flex-end; }
.modal-actions button { padding: 10px 20px; border-radius: 6px; border: none; cursor: pointer; font-weight: 600; }
.btn-cancel { background: #f3f4f6; color: #374151; }
.btn-confirm { background: #3b82f6; color: white; }
</style>
<div class="modal-overlay">
  <div class="modal">
    <h2>Confirm Action</h2>
    <p>Are you sure you want to proceed? This action cannot be undone.</p>
    <div class="modal-actions">
      <button class="btn-cancel" onclick="this.closest('.modal-overlay').remove()">Cancel</button>
      <button class="btn-confirm">Confirm</button>
    </div>
  </div>
</div>
EOF
}

cmd_form() {
cat << 'EOF'
<!-- Form Components -->
<style>
.form { max-width: 420px; padding: 32px; background: white; border-radius: 12px; box-shadow: 0 4px 24px rgba(0,0,0,0.08); }
.form-group { margin-bottom: 20px; }
.form-group label { display: block; margin-bottom: 6px; font-weight: 600; font-size: 14px; color: #374151; }
.form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px 14px; border: 1px solid #d1d5db; border-radius: 8px; font-size: 14px; transition: border-color 0.2s; box-sizing: border-box; }
.form-group input:focus, .form-group textarea:focus { outline: none; border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
.form-hint { font-size: 12px; color: #9ca3af; margin-top: 4px; }
.form-submit { width: 100%; padding: 12px; background: #3b82f6; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; }
.form-submit:hover { background: #2563eb; }
</style>
<form class="form">
  <div class="form-group">
    <label>Email</label>
    <input type="email" placeholder="you@example.com">
    <div class="form-hint">We'll never share your email.</div>
  </div>
  <div class="form-group">
    <label>Password</label>
    <input type="password" placeholder="••••••••">
  </div>
  <div class="form-group">
    <label>Role</label>
    <select><option>Developer</option><option>Designer</option><option>Manager</option></select>
  </div>
  <div class="form-group">
    <label>Message</label>
    <textarea rows="3" placeholder="Tell us more..."></textarea>
  </div>
  <button type="submit" class="form-submit">Submit</button>
</form>
EOF
}

cmd_table() {
cat << 'EOF'
<!-- Data Table -->
<style>
.data-table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
.data-table th { background: #f9fafb; padding: 12px 16px; text-align: left; font-size: 12px; text-transform: uppercase; color: #6b7280; border-bottom: 2px solid #e5e7eb; }
.data-table td { padding: 12px 16px; border-bottom: 1px solid #f3f4f6; font-size: 14px; }
.data-table tr:hover { background: #f9fafb; }
.badge { padding: 2px 10px; border-radius: 999px; font-size: 12px; font-weight: 600; }
.badge-green { background: #dcfce7; color: #166534; }
.badge-yellow { background: #fef9c3; color: #854d0e; }
.badge-red { background: #fee2e2; color: #991b1b; }
</style>
<table class="data-table">
  <thead><tr><th>Name</th><th>Email</th><th>Status</th><th>Role</th></tr></thead>
  <tbody>
    <tr><td>Jane Cooper</td><td>jane@example.com</td><td><span class="badge badge-green">Active</span></td><td>Admin</td></tr>
    <tr><td>John Smith</td><td>john@example.com</td><td><span class="badge badge-yellow">Pending</span></td><td>Editor</td></tr>
    <tr><td>Bob Wilson</td><td>bob@example.com</td><td><span class="badge badge-red">Inactive</span></td><td>Viewer</td></tr>
  </tbody>
</table>
EOF
}

cmd_hero() {
cat << 'EOF'
<!-- Hero Section -->
<style>
.hero { padding: 80px 24px; text-align: center; background: linear-gradient(135deg, #1e3a5f 0%, #0f172a 100%); color: white; }
.hero h1 { font-size: 48px; font-weight: 800; margin: 0 0 16px; line-height: 1.1; }
.hero h1 span { background: linear-gradient(90deg, #60a5fa, #a78bfa); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.hero p { font-size: 20px; color: #94a3b8; max-width: 600px; margin: 0 auto 32px; }
.hero-buttons { display: flex; gap: 16px; justify-content: center; }
.hero-btn { padding: 14px 28px; border-radius: 8px; font-size: 16px; font-weight: 600; text-decoration: none; }
.hero-btn-primary { background: #3b82f6; color: white; }
.hero-btn-ghost { background: transparent; color: white; border: 1px solid rgba(255,255,255,0.2); }
</style>
<section class="hero">
  <h1>Build <span>Amazing</span> Products</h1>
  <p>The all-in-one platform for modern teams to ship faster and collaborate better.</p>
  <div class="hero-buttons">
    <a href="#" class="hero-btn hero-btn-primary">Get Started Free</a>
    <a href="#" class="hero-btn hero-btn-ghost">Watch Demo →</a>
  </div>
</section>
EOF
}

cmd_footer() {
cat << 'EOF'
<!-- Footer -->
<style>
.footer { background: #111827; color: #9ca3af; padding: 48px 24px 24px; }
.footer-grid { display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 32px; max-width: 1200px; margin: 0 auto; }
.footer-brand h3 { color: white; font-size: 20px; margin: 0 0 12px; }
.footer-brand p { font-size: 14px; line-height: 1.6; }
.footer-col h4 { color: white; font-size: 14px; margin: 0 0 16px; }
.footer-col a { display: block; color: #9ca3af; text-decoration: none; font-size: 14px; margin-bottom: 8px; }
.footer-col a:hover { color: white; }
.footer-bottom { border-top: 1px solid #1f2937; margin-top: 32px; padding-top: 24px; text-align: center; font-size: 13px; }
</style>
<footer class="footer">
  <div class="footer-grid">
    <div class="footer-brand"><h3>Brand</h3><p>Building the future, one component at a time.</p></div>
    <div class="footer-col"><h4>Product</h4><a href="#">Features</a><a href="#">Pricing</a><a href="#">Docs</a></div>
    <div class="footer-col"><h4>Company</h4><a href="#">About</a><a href="#">Blog</a><a href="#">Careers</a></div>
    <div class="footer-col"><h4>Legal</h4><a href="#">Privacy</a><a href="#">Terms</a></div>
  </div>
  <div class="footer-bottom">© 2024 Brand. All rights reserved.</div>
</footer>
EOF
}

cmd_grid() {
cat << 'EOF'
<!-- Responsive Grid Layout -->
<style>
.grid-demo { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 24px; padding: 24px; }
.grid-item { background: white; border-radius: 8px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
.grid-item h3 { margin: 0 0 8px; font-size: 18px; }
.grid-item p { margin: 0; color: #6b7280; font-size: 14px; }
</style>
<div class="grid-demo">
  <div class="grid-item"><h3>Feature 1</h3><p>Description of the first feature.</p></div>
  <div class="grid-item"><h3>Feature 2</h3><p>Description of the second feature.</p></div>
  <div class="grid-item"><h3>Feature 3</h3><p>Description of the third feature.</p></div>
  <div class="grid-item"><h3>Feature 4</h3><p>Description of the fourth feature.</p></div>
</div>
EOF
}

cmd_alert() {
cat << 'EOF'
<!-- Alert / Notification Components -->
<style>
.alert { padding: 16px 20px; border-radius: 8px; margin-bottom: 12px; display: flex; align-items: flex-start; gap: 12px; font-size: 14px; }
.alert-icon { font-size: 20px; flex-shrink: 0; }
.alert-info { background: #eff6ff; color: #1e40af; border-left: 4px solid #3b82f6; }
.alert-success { background: #f0fdf4; color: #166534; border-left: 4px solid #22c55e; }
.alert-warning { background: #fffbeb; color: #92400e; border-left: 4px solid #f59e0b; }
.alert-error { background: #fef2f2; color: #991b1b; border-left: 4px solid #ef4444; }
.alert strong { display: block; margin-bottom: 4px; }
</style>
<div class="alert alert-info"><span class="alert-icon">ℹ️</span><div><strong>Information</strong>A new version is available. Please update.</div></div>
<div class="alert alert-success"><span class="alert-icon">✅</span><div><strong>Success</strong>Your changes have been saved successfully.</div></div>
<div class="alert alert-warning"><span class="alert-icon">⚠️</span><div><strong>Warning</strong>Your subscription expires in 3 days.</div></div>
<div class="alert alert-error"><span class="alert-icon">❌</span><div><strong>Error</strong>Failed to process payment. Please try again.</div></div>
EOF
}

case "$CMD" in
  help|--help|-h) show_help ;;
  button|btn) cmd_button ;;
  card) cmd_card ;;
  navbar|nav) cmd_navbar ;;
  modal|dialog) cmd_modal ;;
  form) cmd_form ;;
  table) cmd_table ;;
  hero) cmd_hero ;;
  footer) cmd_footer ;;
  grid|layout) cmd_grid ;;
  alert|notification) cmd_alert ;;
  *) echo "Unknown command: $CMD"; show_help; exit 1 ;;
esac
