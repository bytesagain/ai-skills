#!/bin/bash
# Minifier - Code Minification Tools Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              MINIFIER REFERENCE                             ║
║          Code Minification & Compression                    ║
╚══════════════════════════════════════════════════════════════╝

Minifiers reduce file size by removing whitespace, comments,
and shortening variable names — making code faster to download
and parse without changing behavior.

MINIFICATION TECHNIQUES:
  Whitespace removal     Spaces, newlines, tabs
  Comment removal        //, /* */, <!-- -->
  Name mangling          longVariableName → a
  Dead code elimination  Remove unreachable code
  Constant folding       2 * 3 → 6
  Shorthand conversion   true → !0, undefined → void 0
  Property shorthand     {name: name} → {name}

MINIFIERS BY TYPE:
  JavaScript   Terser, esbuild, SWC, UglifyJS
  CSS          cssnano, Lightning CSS, clean-css
  HTML         html-minifier-terser
  SVG          svgo
  JSON         json-minify
  Images       imagemin, squoosh, sharp

SIZE BUDGET TARGETS:
  JavaScript     < 200 KB (compressed)
  CSS            < 50 KB (compressed)
  HTML           < 50 KB
  First load     < 100 KB JS (critical path)
  Total page     < 1 MB (all resources)
EOF
}

cmd_javascript() {
cat << 'EOF'
JAVASCRIPT MINIFICATION
=========================

TERSER (standard, UglifyJS successor):
  npm install terser

  npx terser input.js -o output.min.js \
    --compress --mangle --source-map

  # Advanced options
  npx terser input.js -o output.min.js \
    --compress "dead_code,drop_console,passes=2" \
    --mangle "toplevel,reserved=['$','jQuery']" \
    --source-map "url=output.min.js.map"

  # API
  import { minify } from 'terser';
  const result = await minify(code, {
    compress: {
      dead_code: true,
      drop_console: true,
      drop_debugger: true,
      passes: 2,
      pure_funcs: ['console.log'],
    },
    mangle: {
      toplevel: true,
      properties: { regex: /^_/ },  // Mangle _private props
    },
    format: { comments: false },
    sourceMap: true,
  });

ESBUILD (fastest):
  npx esbuild input.js --minify --outfile=output.min.js
  npx esbuild input.js --minify --sourcemap --bundle \
    --target=es2020 --outfile=output.min.js

  # Minify-only (no bundle):
  npx esbuild --minify --loader=js < input.js > output.min.js

SWC:
  npx swc input.js -o output.min.js --minify
  
  // .swcrc
  { "minify": true, "jsc": { "minify": {
    "compress": true,
    "mangle": true
  }}}

SPEED COMPARISON (1MB input):
  esbuild      ~10ms
  SWC          ~30ms
  Terser       ~1000ms
  UglifyJS     ~3000ms

WEBPACK INTEGRATION:
  // webpack.config.js
  const TerserPlugin = require('terser-webpack-plugin');
  optimization: {
    minimize: true,
    minimizer: [
      new TerserPlugin({
        terserOptions: {
          compress: { drop_console: true },
        },
        extractComments: false,
      }),
    ],
  }
EOF
}

cmd_css_assets() {
cat << 'EOF'
CSS, HTML, AND ASSET MINIFICATION
====================================

CSSNANO:
  npm install cssnano postcss postcss-cli

  // postcss.config.js
  module.exports = {
    plugins: [require('cssnano')({ preset: 'default' })],
  };

  npx postcss src/*.css -d dist/
  
  // What cssnano does:
  // margin: 10px 10px 10px 10px → margin: 10px
  // #ff0000 → red → #f00
  // calc(2 * 50%) → 100%
  // Removes duplicate rules
  // Merges selectors

LIGHTNING CSS (Rust-based, fastest):
  npm install lightningcss-cli

  npx lightningcss --minify --bundle input.css -o output.css
  npx lightningcss --minify --targets ">= 0.25%" input.css

  // API
  import { transform } from 'lightningcss';
  const { code, map } = transform({
    filename: 'style.css',
    code: Buffer.from(cssString),
    minify: true,
    targets: { chrome: 90 },
  });

HTML-MINIFIER-TERSER:
  npm install html-minifier-terser

  npx html-minifier-terser --collapse-whitespace \
    --remove-comments --minify-css true \
    --minify-js true -o output.html input.html

SVGO (SVG optimizer):
  npm install svgo

  npx svgo input.svg -o output.svg
  npx svgo -f ./svg-folder/        # Folder
  npx svgo --multipass input.svg   # Multiple passes

  // svgo.config.mjs
  export default {
    multipass: true,
    plugins: [
      'preset-default',
      'removeDimensions',
      { name: 'removeAttrs', params: { attrs: '(fill|stroke)' } },
    ],
  };

IMAGE OPTIMIZATION:
  # sharp (Node.js)
  import sharp from 'sharp';
  await sharp('input.jpg')
    .resize(800)
    .webp({ quality: 80 })
    .toFile('output.webp');

  # squoosh-cli
  npx @squoosh/cli --webp auto input.jpg

GZIP / BROTLI:
  # Most important: enable compression on your server
  # Nginx
  gzip on; gzip_types text/css application/javascript;
  brotli on; brotli_types text/css application/javascript;

  # Pre-compress at build time
  npx gzip-size-cli dist/bundle.js  # Check gzip size

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Minifier - Code Minification Tools Reference

Commands:
  intro        Overview, techniques, budgets
  javascript   Terser, esbuild, SWC, Webpack
  css_assets   cssnano, Lightning CSS, SVGO, images

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  javascript) cmd_javascript ;;
  css_assets) cmd_css_assets ;;
  help|*)     show_help ;;
esac
