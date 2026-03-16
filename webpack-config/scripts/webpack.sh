#!/usr/bin/env bash
# Webpack Config Generator — generates real webpack.config.js
# Usage: webpack.sh <command> [options]

set -euo pipefail

CMD="${1:-help}"; shift 2>/dev/null || true

# Parse flags
TYPE="vanilla" ENTRY="./src/index.js" OUTPUT="dist" PORT="8080"
LOADER_TYPE="" SOURCEMAP="true" HASH="true" MODE="production"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --type)      TYPE="$2"; shift 2 ;;
        --entry)     ENTRY="$2"; shift 2 ;;
        --output)    OUTPUT="$2"; shift 2 ;;
        --port)      PORT="$2"; shift 2 ;;
        --loader)    LOADER_TYPE="$2"; shift 2 ;;
        --no-hash)   HASH="no"; shift ;;
        --no-sourcemap) SOURCEMAP="false"; shift ;;
        --mode)      MODE="$2"; shift 2 ;;
        *) shift ;;
    esac
done

hash_suffix() {
    if [[ "$HASH" == "yes" ]]; then
        echo ".[contenthash:8]"
    fi
}

gen_vanilla() {
    local h
    h=$(hash_suffix)
    cat <<JS
// ============================================
// Webpack 配置 — Vanilla JS
// 生成时间: $(date '+%Y-%m-%d %H:%M:%S')
// ============================================
// 安装依赖:
//   npm init -y
//   npm install -D webpack webpack-cli webpack-dev-server
//   npm install -D html-webpack-plugin mini-css-extract-plugin
//   npm install -D css-loader style-loader babel-loader @babel/core @babel/preset-env
//   npm install -D copy-webpack-plugin terser-webpack-plugin css-minimizer-webpack-plugin

const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');

const isDev = process.env.NODE_ENV !== 'production';

module.exports = {
    mode: isDev ? 'development' : 'production',

    entry: '${ENTRY}',

    output: {
        path: path.resolve(__dirname, '${OUTPUT}'),
        filename: isDev ? 'js/[name].js' : 'js/[name]${h}.js',
        clean: true,  // 构建前清空 output 目录
        publicPath: '/',
    },

    devtool: isDev ? 'eval-cheap-module-source-map' : ${SOURCEMAP} ? 'source-map' : false,

    devServer: {
        port: ${PORT},
        hot: true,
        open: true,
        historyApiFallback: true,  // SPA 路由支持
        compress: true,
        client: {
            overlay: { errors: true, warnings: false },
        },
    },

    module: {
        rules: [
            // JavaScript — Babel
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/preset-env'],
                        cacheDirectory: true,
                    },
                },
            },
            // CSS
            {
                test: /\.css$/,
                use: [
                    isDev ? 'style-loader' : MiniCssExtractPlugin.loader,
                    'css-loader',
                ],
            },
            // 图片
            {
                test: /\.(png|jpe?g|gif|svg|webp|avif)$/i,
                type: 'asset',
                parser: { dataUrlCondition: { maxSize: 8 * 1024 } },
                generator: { filename: 'images/[name]${h}[ext]' },
            },
            // 字体
            {
                test: /\.(woff2?|eot|ttf|otf)$/i,
                type: 'asset/resource',
                generator: { filename: 'fonts/[name]${h}[ext]' },
            },
        ],
    },

    plugins: [
        new HtmlWebpackPlugin({
            template: './public/index.html',
            title: 'My App',
            minify: !isDev ? {
                removeComments: true,
                collapseWhitespace: true,
                removeAttributeQuotes: true,
            } : false,
        }),
        !isDev && new MiniCssExtractPlugin({
            filename: 'css/[name]${h}.css',
        }),
    ].filter(Boolean),

    optimization: {
        minimizer: [
            new TerserPlugin({ terserOptions: { compress: { drop_console: true } } }),
            new CssMinimizerPlugin(),
        ],
        splitChunks: {
            chunks: 'all',
            cacheGroups: {
                vendor: {
                    test: /[\\\\/]node_modules[\\\\/]/,
                    name: 'vendor',
                    chunks: 'all',
                },
            },
        },
    },

    resolve: {
        extensions: ['.js', '.json'],
        alias: {
            '@': path.resolve(__dirname, 'src'),
        },
    },

    stats: isDev ? 'minimal' : 'normal',
};
JS
}

gen_react() {
    local h
    h=$(hash_suffix)
    cat <<JS
// ============================================
// Webpack 配置 — React
// 生成时间: $(date '+%Y-%m-%d %H:%M:%S')
// ============================================
// 安装依赖:
//   npm install react react-dom
//   npm install -D webpack webpack-cli webpack-dev-server
//   npm install -D html-webpack-plugin mini-css-extract-plugin
//   npm install -D babel-loader @babel/core @babel/preset-env @babel/preset-react
//   npm install -D css-loader style-loader sass-loader sass
//   npm install -D terser-webpack-plugin css-minimizer-webpack-plugin
//   npm install -D @pmmmwh/react-refresh-webpack-plugin react-refresh

const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const ReactRefreshPlugin = require('@pmmmwh/react-refresh-webpack-plugin');

const isDev = process.env.NODE_ENV !== 'production';

module.exports = {
    mode: isDev ? 'development' : 'production',

    entry: '${ENTRY}',

    output: {
        path: path.resolve(__dirname, '${OUTPUT}'),
        filename: isDev ? 'js/[name].js' : 'js/[name]${h}.js',
        chunkFilename: isDev ? 'js/[name].chunk.js' : 'js/[name]${h}.chunk.js',
        clean: true,
        publicPath: '/',
    },

    devtool: isDev ? 'eval-cheap-module-source-map' : ${SOURCEMAP} ? 'source-map' : false,

    devServer: {
        port: ${PORT},
        hot: true,
        open: true,
        historyApiFallback: true,
        compress: true,
        client: {
            overlay: { errors: true, warnings: false },
        },
    },

    module: {
        rules: [
            // JSX / JS — Babel + React
            {
                test: /\.(js|jsx)$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: [
                            '@babel/preset-env',
                            ['@babel/preset-react', { runtime: 'automatic' }],
                        ],
                        plugins: isDev ? [require.resolve('react-refresh/babel')] : [],
                        cacheDirectory: true,
                    },
                },
            },
            // CSS
            {
                test: /\.css$/,
                use: [
                    isDev ? 'style-loader' : MiniCssExtractPlugin.loader,
                    { loader: 'css-loader', options: { modules: { auto: true } } },
                ],
            },
            // SCSS/SASS
            {
                test: /\.s[ac]ss$/,
                use: [
                    isDev ? 'style-loader' : MiniCssExtractPlugin.loader,
                    { loader: 'css-loader', options: { modules: { auto: true } } },
                    'sass-loader',
                ],
            },
            // 图片
            {
                test: /\.(png|jpe?g|gif|svg|webp)$/i,
                type: 'asset',
                parser: { dataUrlCondition: { maxSize: 10 * 1024 } },
                generator: { filename: 'images/[name]${h}[ext]' },
            },
            // 字体
            {
                test: /\.(woff2?|eot|ttf|otf)$/i,
                type: 'asset/resource',
                generator: { filename: 'fonts/[name]${h}[ext]' },
            },
        ],
    },

    plugins: [
        new HtmlWebpackPlugin({
            template: './public/index.html',
            favicon: './public/favicon.ico',
        }),
        isDev && new ReactRefreshPlugin(),
        !isDev && new MiniCssExtractPlugin({
            filename: 'css/[name]${h}.css',
            chunkFilename: 'css/[name]${h}.chunk.css',
        }),
    ].filter(Boolean),

    optimization: {
        minimize: !isDev,
        minimizer: [
            new TerserPlugin({
                terserOptions: { compress: { drop_console: true, drop_debugger: true } },
            }),
            new CssMinimizerPlugin(),
        ],
        splitChunks: {
            chunks: 'all',
            cacheGroups: {
                react: {
                    test: /[\\\\/]node_modules[\\\\/](react|react-dom)[\\\\/]/,
                    name: 'react-vendor',
                    priority: 20,
                },
                vendor: {
                    test: /[\\\\/]node_modules[\\\\/]/,
                    name: 'vendor',
                    priority: 10,
                },
            },
        },
        runtimeChunk: 'single',
    },

    resolve: {
        extensions: ['.js', '.jsx', '.json'],
        alias: {
            '@': path.resolve(__dirname, 'src'),
            '@components': path.resolve(__dirname, 'src/components'),
            '@pages': path.resolve(__dirname, 'src/pages'),
            '@utils': path.resolve(__dirname, 'src/utils'),
        },
    },

    stats: isDev ? 'minimal' : 'normal',
};
JS
}

gen_vue() {
    local h
    h=$(hash_suffix)
    cat <<JS
// ============================================
// Webpack 配置 — Vue 3
// 生成时间: $(date '+%Y-%m-%d %H:%M:%S')
// ============================================
// 安装依赖:
//   npm install vue@3
//   npm install -D webpack webpack-cli webpack-dev-server
//   npm install -D vue-loader@next @vue/compiler-sfc
//   npm install -D html-webpack-plugin mini-css-extract-plugin
//   npm install -D babel-loader @babel/core @babel/preset-env
//   npm install -D css-loader style-loader sass-loader sass
//   npm install -D terser-webpack-plugin css-minimizer-webpack-plugin

const path = require('path');
const { VueLoaderPlugin } = require('vue-loader');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const { DefinePlugin } = require('webpack');

const isDev = process.env.NODE_ENV !== 'production';

module.exports = {
    mode: isDev ? 'development' : 'production',

    entry: '${ENTRY}',

    output: {
        path: path.resolve(__dirname, '${OUTPUT}'),
        filename: isDev ? 'js/[name].js' : 'js/[name]${h}.js',
        chunkFilename: isDev ? 'js/[name].chunk.js' : 'js/[name]${h}.chunk.js',
        clean: true,
        publicPath: '/',
    },

    devtool: isDev ? 'eval-cheap-module-source-map' : ${SOURCEMAP} ? 'source-map' : false,

    devServer: {
        port: ${PORT},
        hot: true,
        open: true,
        historyApiFallback: true,
        compress: true,
    },

    module: {
        rules: [
            // Vue SFC
            {
                test: /\.vue$/,
                loader: 'vue-loader',
            },
            // JavaScript
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/preset-env'],
                        cacheDirectory: true,
                    },
                },
            },
            // CSS
            {
                test: /\.css$/,
                use: [
                    isDev ? 'style-loader' : MiniCssExtractPlugin.loader,
                    'css-loader',
                ],
            },
            // SCSS
            {
                test: /\.s[ac]ss$/,
                use: [
                    isDev ? 'style-loader' : MiniCssExtractPlugin.loader,
                    'css-loader',
                    'sass-loader',
                ],
            },
            // 图片
            {
                test: /\.(png|jpe?g|gif|svg|webp)$/i,
                type: 'asset',
                parser: { dataUrlCondition: { maxSize: 10 * 1024 } },
                generator: { filename: 'images/[name]${h}[ext]' },
            },
            // 字体
            {
                test: /\.(woff2?|eot|ttf|otf)$/i,
                type: 'asset/resource',
                generator: { filename: 'fonts/[name]${h}[ext]' },
            },
        ],
    },

    plugins: [
        new VueLoaderPlugin(),
        new HtmlWebpackPlugin({
            template: './public/index.html',
        }),
        new DefinePlugin({
            __VUE_OPTIONS_API__: JSON.stringify(true),
            __VUE_PROD_DEVTOOLS__: JSON.stringify(false),
            __VUE_PROD_HYDRATION_MISMATCH_DETAILS__: JSON.stringify(false),
        }),
        !isDev && new MiniCssExtractPlugin({
            filename: 'css/[name]${h}.css',
        }),
    ].filter(Boolean),

    optimization: {
        minimize: !isDev,
        minimizer: [
            new TerserPlugin({ terserOptions: { compress: { drop_console: true } } }),
            new CssMinimizerPlugin(),
        ],
        splitChunks: {
            chunks: 'all',
            cacheGroups: {
                vue: {
                    test: /[\\\\/]node_modules[\\\\/](vue|@vue)[\\\\/]/,
                    name: 'vue-vendor',
                    priority: 20,
                },
                vendor: {
                    test: /[\\\\/]node_modules[\\\\/]/,
                    name: 'vendor',
                    priority: 10,
                },
            },
        },
    },

    resolve: {
        extensions: ['.vue', '.js', '.json'],
        alias: {
            '@': path.resolve(__dirname, 'src'),
        },
    },

    stats: isDev ? 'minimal' : 'normal',
};
JS
}

gen_typescript() {
    local h
    h=$(hash_suffix)
    cat <<JS
// ============================================
// Webpack 配置 — TypeScript
// 生成时间: $(date '+%Y-%m-%d %H:%M:%S')
// ============================================
// 安装依赖:
//   npm install -D webpack webpack-cli webpack-dev-server
//   npm install -D ts-loader typescript
//   npm install -D html-webpack-plugin mini-css-extract-plugin
//   npm install -D css-loader style-loader
//   npm install -D terser-webpack-plugin css-minimizer-webpack-plugin
//   npx tsc --init  # 生成 tsconfig.json

const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');

const isDev = process.env.NODE_ENV !== 'production';

module.exports = {
    mode: isDev ? 'development' : 'production',

    entry: './src/index.ts',

    output: {
        path: path.resolve(__dirname, '${OUTPUT}'),
        filename: isDev ? 'js/[name].js' : 'js/[name]${h}.js',
        clean: true,
        publicPath: '/',
    },

    devtool: isDev ? 'eval-cheap-module-source-map' : ${SOURCEMAP} ? 'source-map' : false,

    devServer: {
        port: ${PORT},
        hot: true,
        open: true,
        historyApiFallback: true,
    },

    module: {
        rules: [
            // TypeScript
            {
                test: /\.tsx?$/,
                use: 'ts-loader',
                exclude: /node_modules/,
            },
            // CSS
            {
                test: /\.css$/,
                use: [
                    isDev ? 'style-loader' : MiniCssExtractPlugin.loader,
                    'css-loader',
                ],
            },
            // 图片
            {
                test: /\.(png|jpe?g|gif|svg|webp)$/i,
                type: 'asset',
                parser: { dataUrlCondition: { maxSize: 8 * 1024 } },
            },
        ],
    },

    plugins: [
        new HtmlWebpackPlugin({ template: './public/index.html' }),
        !isDev && new MiniCssExtractPlugin({ filename: 'css/[name]${h}.css' }),
    ].filter(Boolean),

    optimization: {
        minimizer: [new TerserPlugin(), new CssMinimizerPlugin()],
        splitChunks: { chunks: 'all' },
    },

    resolve: {
        extensions: ['.ts', '.tsx', '.js', '.json'],
        alias: { '@': path.resolve(__dirname, 'src') },
    },
};
JS
}

gen_add_loader() {
    case "${LOADER_TYPE:-}" in
        css)
            cat <<'JS'
// ---- CSS Loader 配置 ----
// npm install -D css-loader style-loader mini-css-extract-plugin

// 在 module.rules 中添加:
{
    test: /\.css$/,
    use: [
        process.env.NODE_ENV !== 'production' ? 'style-loader' : MiniCssExtractPlugin.loader,
        'css-loader',
    ],
},

// CSS Modules:
{
    test: /\.module\.css$/,
    use: [
        'style-loader',
        { loader: 'css-loader', options: { modules: true } },
    ],
},
JS
            ;;
        sass|scss)
            cat <<'JS'
// ---- SASS/SCSS Loader 配置 ----
// npm install -D sass-loader sass css-loader style-loader

// 在 module.rules 中添加:
{
    test: /\.s[ac]ss$/i,
    use: [
        'style-loader',  // 生产环境换 MiniCssExtractPlugin.loader
        'css-loader',
        'sass-loader',
    ],
},
JS
            ;;
        babel)
            cat <<'JS'
// ---- Babel Loader 配置 ----
// npm install -D babel-loader @babel/core @babel/preset-env

// 在 module.rules 中添加:
{
    test: /\.m?js$/,
    exclude: /node_modules/,
    use: {
        loader: 'babel-loader',
        options: {
            presets: ['@babel/preset-env'],
            // React 项目加: '@babel/preset-react'
            // TypeScript 加: '@babel/preset-typescript'
            cacheDirectory: true,
        },
    },
},
JS
            ;;
        typescript|ts)
            cat <<'JS'
// ---- TypeScript Loader 配置 ----
// npm install -D ts-loader typescript
// npx tsc --init  (生成 tsconfig.json)

// 在 module.rules 中添加:
{
    test: /\.tsx?$/,
    use: 'ts-loader',
    exclude: /node_modules/,
},

// 在 resolve.extensions 中添加:
// extensions: ['.ts', '.tsx', '.js', '.json'],
JS
            ;;
        image|images)
            cat <<'JS'
// ---- 图片资源配置 (Webpack 5 内置) ----
// 无需安装额外 loader

// 在 module.rules 中添加:
{
    test: /\.(png|jpe?g|gif|svg|webp|avif)$/i,
    type: 'asset',
    parser: {
        dataUrlCondition: {
            maxSize: 8 * 1024,  // 8KB 以下转 base64
        },
    },
    generator: {
        filename: 'images/[name].[contenthash:8][ext]',
    },
},
JS
            ;;
        font|fonts)
            cat <<'JS'
// ---- 字体资源配置 ----
{
    test: /\.(woff2?|eot|ttf|otf)$/i,
    type: 'asset/resource',
    generator: {
        filename: 'fonts/[name].[contenthash:8][ext]',
    },
},
JS
            ;;
        *)
            cat <<'EOF'
可用 loader 类型:
  css        CSS / CSS Modules
  sass       SASS/SCSS
  babel      Babel (ES6+)
  typescript TypeScript
  image      图片资源
  font       字体资源

用法: webpack.sh add-loader --type <type>
EOF
            ;;
    esac
}

case "$CMD" in
    init|generate|gen)
        case "$TYPE" in
            vanilla|js)     gen_vanilla ;;
            react)          gen_react ;;
            vue)            gen_vue ;;
            typescript|ts)  gen_typescript ;;
            *)
                echo "可用类型: vanilla, react, vue, typescript"
                echo "用法: webpack.sh init --type <type>"
                ;;
        esac
        ;;
    add-loader|loader|add)
        gen_add_loader ;;
    *)
        cat <<'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📦 Webpack Config Generator — 使用指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  命令                 说明
  ──────────────────────────────────────────
  init                 生成完整 webpack.config.js
    --type TYPE          项目类型:
                         vanilla (默认)
                         react
                         vue
                         typescript
    --entry PATH         入口文件 (默认: ./src/index.js)
    --output DIR         输出目录 (默认: dist)
    --port NUM           开发服务器端口 (默认: 8080)
    --no-hash            文件名不加 hash
    --no-sourcemap       不生成 sourcemap

  add-loader           添加 loader 配置片段
    --type TYPE          loader 类型:
                         css, sass, babel, typescript,
                         image, font

  示例:
    webpack.sh init --type react --port 3000
    webpack.sh init --type vue --entry ./src/main.js
    webpack.sh init --type typescript
    webpack.sh init --type vanilla --no-hash
    webpack.sh add-loader --type sass
    webpack.sh add-loader --type typescript
EOF
        ;;
esac
