#!/bin/bash
# Bundler - JavaScript Module Bundlers Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              BUNDLER REFERENCE                              ║
║          JavaScript Module Bundlers                         ║
╚══════════════════════════════════════════════════════════════╝

Bundlers combine JavaScript modules, CSS, images, and other
assets into optimized files for production deployment.

BUNDLER LANDSCAPE (2026):
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Bundler      │ Speed    │ Use Case │ Language  │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Vite         │ Fast     │ Apps     │ JS+Rust  │
  │ esbuild      │ Fastest  │ Libraries│ Go       │
  │ Rollup       │ Medium   │ Libraries│ JS+Rust  │
  │ Webpack      │ Slow     │ Legacy   │ JS       │
  │ Turbopack    │ Fast     │ Next.js  │ Rust     │
  │ Rspack       │ Fast     │ Webpack  │ Rust     │
  │ Parcel       │ Medium   │ Zero-cfg │ Rust     │
  │ SWC          │ Fastest  │ Transform│ Rust     │
  │ Bun bundler  │ Fast     │ Bun apps │ Zig      │
  └──────────────┴──────────┴──────────┴──────────┘

KEY CONCEPTS:
  Entry point    Where bundling starts (index.js)
  Output         Bundled file(s) (dist/bundle.js)
  Loader/Plugin  Transform non-JS (CSS, images, TS)
  Code splitting Lazy-load chunks on demand
  Tree shaking   Remove unused exports (dead code)
  HMR            Hot Module Replacement (dev server)
  Source maps    Debug original source in browser
  Chunk          Split bundle piece
EOF
}

cmd_vite_esbuild() {
cat << 'EOF'
VITE & ESBUILD
=================

VITE:
  npm create vite@latest my-app -- --template react-ts
  cd my-app && npm install

  # vite.config.ts
  import { defineConfig } from 'vite';
  import react from '@vitejs/plugin-react';

  export default defineConfig({
    plugins: [react()],
    server: {
      port: 3000,
      proxy: {
        '/api': 'http://localhost:8080',
      },
    },
    build: {
      target: 'es2020',
      outDir: 'dist',
      sourcemap: true,
      rollupOptions: {
        output: {
          manualChunks: {
            vendor: ['react', 'react-dom'],
            charts: ['recharts'],
          },
        },
      },
    },
    resolve: {
      alias: { '@': '/src' },
    },
  });

  npx vite                  # Dev server (HMR)
  npx vite build            # Production build
  npx vite preview          # Preview production build

  # Environment variables
  VITE_API_URL=https://api.example.com   # .env
  import.meta.env.VITE_API_URL           # In code

ESBUILD:
  npm install esbuild

  # CLI
  npx esbuild src/index.ts --bundle --outfile=dist/bundle.js
  npx esbuild src/index.ts --bundle --minify --sourcemap \
    --target=es2020 --format=esm --outdir=dist

  # API
  import { build } from 'esbuild';
  await build({
    entryPoints: ['src/index.ts'],
    bundle: true,
    minify: true,
    sourcemap: true,
    target: ['es2020'],
    format: 'esm',
    outdir: 'dist',
    splitting: true,       // Code splitting (ESM only)
    external: ['react'],   // Don't bundle
    define: { 'process.env.NODE_ENV': '"production"' },
    loader: { '.png': 'dataurl', '.svg': 'text' },
  });

  # Watch mode
  const ctx = await context({ /* same options */ });
  await ctx.watch();
  await ctx.serve({ port: 3000 });
EOF
}

cmd_webpack_rollup() {
cat << 'EOF'
WEBPACK & ROLLUP
==================

WEBPACK 5:
  npm install webpack webpack-cli webpack-dev-server

  // webpack.config.js
  const path = require('path');
  const HtmlPlugin = require('html-webpack-plugin');
  const MiniCss = require('mini-css-extract-plugin');

  module.exports = {
    mode: 'production',
    entry: './src/index.js',
    output: {
      path: path.resolve(__dirname, 'dist'),
      filename: '[name].[contenthash].js',
      clean: true,
    },
    module: {
      rules: [
        { test: /\.tsx?$/, use: 'ts-loader', exclude: /node_modules/ },
        { test: /\.css$/, use: [MiniCss.loader, 'css-loader', 'postcss-loader'] },
        { test: /\.(png|svg|jpg)$/, type: 'asset/resource' },
      ],
    },
    plugins: [
      new HtmlPlugin({ template: './src/index.html' }),
      new MiniCss({ filename: '[name].[contenthash].css' }),
    ],
    optimization: {
      splitChunks: { chunks: 'all' },
      runtimeChunk: 'single',
    },
    devServer: { hot: true, port: 3000 },
    resolve: { extensions: ['.ts', '.tsx', '.js'] },
  };

  npx webpack                 # Build
  npx webpack serve           # Dev server

ROLLUP (library bundling):
  npm install rollup @rollup/plugin-node-resolve @rollup/plugin-commonjs

  // rollup.config.mjs
  import resolve from '@rollup/plugin-node-resolve';
  import commonjs from '@rollup/plugin-commonjs';
  import typescript from '@rollup/plugin-typescript';
  import terser from '@rollup/plugin-terser';

  export default {
    input: 'src/index.ts',
    output: [
      { file: 'dist/index.cjs.js', format: 'cjs' },
      { file: 'dist/index.esm.js', format: 'esm' },
      { file: 'dist/index.umd.js', format: 'umd', name: 'MyLib' },
    ],
    plugins: [resolve(), commonjs(), typescript(), terser()],
    external: ['react', 'react-dom'],  // Peer deps
  };

RSPACK (Webpack-compatible, Rust):
  npm create rspack@latest
  // Same webpack.config.js syntax, 5-10x faster

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Bundler - JavaScript Module Bundlers Reference

Commands:
  intro           Overview, comparison table
  vite_esbuild    Vite config, esbuild API
  webpack_rollup  Webpack 5, Rollup, Rspack

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)          cmd_intro ;;
  vite_esbuild)   cmd_vite_esbuild ;;
  webpack_rollup) cmd_webpack_rollup ;;
  help|*)         show_help ;;
esac
