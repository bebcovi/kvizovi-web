const webpack = require('webpack');
const HtmlPlugin = require('html-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const autoprefixer = require('autoprefixer');
const resolve = require('path').resolve;

const env = process.env.NODE_ENV || 'development';

const ENTRY = {
  development: [
    'babel-polyfill',
    'webpack-hot-middleware/client',
    './src',
  ],
  test: './test',
  production: [
    'babel-polyfill',
    './src',
  ],
};

const OUTPUT = {
  development: {
    path: resolve('./dist'),
    filename: 'bundle.js',
    publicPath: '/',
  },
  test: {
    path: resolve('./.tmp'),
    filename: 'test.js',
    publicPath: '/',
  },
  production: {
    path: resolve('./dist'),
    filename: '[hash].js',
    publicPath: '/',
  },
};

const PLUGINS = {
  development: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin(),
    new HtmlPlugin({
      template: './src/index.html',
      inject: true,
      favicon: './src/favicon.ico',
      hash: true,
    }),
  ],
  production: [
    new webpack.optimize.UglifyJsPlugin({
      compressor: { warnings: false },
    }),
    new ExtractTextPlugin('[hash].css', { allChunks: true }),
    new HtmlPlugin({
      template: './src/index.html',
      inject: true,
      favicon: './src/favicon.ico',
    }),
  ],
};

const MODULE = {
  test: {
    // isomorphic-fetch fix
    // https://github.com/webpack/webpack/issues/198#issuecomment-37306725
    // require(expr)
    exprContextRegExp: /$^/,
    exprContextCritical: false,
  },
};

const LOCAL_IDENT_NAME = '[name]__[local]___[hash:base64:5]';
const STYLES_MODULES_LOADER = {
  development: `style!css?modules&localIdentName=${LOCAL_IDENT_NAME}&importLoaders=1!postcss!sass`,
  test: 'null',
  production: ExtractTextPlugin.extract('style', 'css?modules&importLoaders=1!postcss!sass'),
};

const STYLES_GLOBAL_LOADER = {
  development: 'style!css?importLoaders=1!postcss!sass',
  test: 'null',
  production: ExtractTextPlugin.extract('style', 'css?importLoaders=1!postcss!sass'),
};

const LESS_LOADER = {
  development: 'style!css?importLoaders=1!postcss!less',
  test: 'null',
  production: ExtractTextPlugin.extract('style', 'css?importLoaders=1!postcss!less'),
};

const IMAGE_LOADER = {
  development: 'url?limit=10000',
  test: 'null',
  production: 'url?limit=10000!image-webpack',
};

module.exports = {
  resolve: {
    extensions: ['', '.webpack.js', '.web.js', '.js', '.json', '.scss'],
  },
  devtool: env !== 'production' ? 'cheap-module-eval-source-map' : undefined,
  target: env === 'test' ? 'node' : 'web',
  entry: ENTRY[env],
  output: OUTPUT[env],
  plugins: [
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV),
      __API_URL__: JSON.stringify(env === 'development' ?
        'http://localhost:3000' :
        'http://api.kvizovi.org'),
      __DEV__: JSON.stringify(env === 'development'),
    }),
    // https://github.com/webpack/webpack/issues/59#issuecomment-12923514
    new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /hr$/),
  ].concat(PLUGINS[env] || []),
  postcss: () => [
    autoprefixer,
  ],
  externals: env === 'test' ? {
    'react/lib/ExecutionEnvironment': true,
    'react/lib/ReactContext': true,
    'react/addons': true,
  } : undefined,
  module: Object.assign({
    loaders: [
      {
        test: /\.js$/,
        include: [resolve('./src'), resolve('./test')],
        loader: 'babel',
      },
      {
        test: /\.json$/,
        loader: 'json',
      },
      {
        include: resolve('./static'),
        loader: 'file?name=[name].[ext]',
      },
      {
        test: /\.s?css$/,
        loader: STYLES_MODULES_LOADER[env],
        include: resolve('./src/styles'),
        exclude: resolve('./src/styles/global'),
      },
      {
        test: /\.s?css$/,
        loader: STYLES_GLOBAL_LOADER[env],
        include: [resolve('./node_modules'), resolve('./src/styles/global')],
      },
      {
        test: /\.less$/,
        loader: LESS_LOADER[env],
      },
      {
        test: /\.(jpe?g|png|gif|svg)$/i,
        loader: IMAGE_LOADER[env],
      },
    ],
  }, MODULE[env]),
};
