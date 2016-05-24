const webpack = require('webpack');
const HtmlPlugin = require('html-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const autoprefixer = require('autoprefixer');
const resolve = require('path').resolve;

const env = process.env.NODE_ENV || 'development';
const IS_PROD = env === 'production';
const IS_DEV = env === 'development';

const PLUGINS = {
  development: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin(),
  ],
  production: [
    new webpack.optimize.UglifyJsPlugin({
      compressor: { warnings: false },
    }),
    new ExtractTextPlugin('[hash].css', { allChunks: true }),
  ],
};

const LOCAL_IDENT_NAME = '[name]__[local]___[hash:base64:5]';
const STYLES_MODULES_LOADER = {
  development: `style!css?modules&localIdentName=${LOCAL_IDENT_NAME}&importLoaders=1!postcss!sass`,
  production: ExtractTextPlugin.extract('style', 'css?modules&importLoaders=1!postcss!sass'),
};

const STYLES_GLOBAL_LOADER = {
  development: 'style!css?importLoaders=1!postcss!sass',
  production: ExtractTextPlugin.extract('style', 'css?importLoaders=1!postcss!sass'),
};

const LESS_LOADER = {
  development: 'style!css?importLoaders=1!postcss!less',
  production: ExtractTextPlugin.extract('style', 'css?importLoaders=1!postcss!less'),
};

const IMAGE_LOADER = {
  development: 'url?limit=10000',
  production: 'url?limit=10000!image-webpack',
};

module.exports = {
  resolve: {
    extensions: ['', '.webpack.js', '.web.js', '.js', '.json', '.scss'],
  },
  devtool: IS_DEV ? 'cheap-module-eval-source-map' : null,
  entry: IS_DEV ? [
    'react-hot-loader/patch',
    'webpack-dev-server/client?http://0.0.0.0:9000',
    'webpack/hot/only-dev-server',
    'babel-polyfill',
    './src',
  ] : [
    'babel-polyfill',
    './src',
  ],
  output: {
    path: resolve('./dist'),
    filename: IS_PROD ? '[hash].js' : 'bundle.js',
    publicPath: '/',
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV),
      __API_URL__: JSON.stringify(IS_PROD ? 'http://api.kvizovi.org' : 'http://localhost:3000'),
      __DEV__: JSON.stringify(IS_DEV),
    }),
    // https://github.com/webpack/webpack/issues/59#issuecomment-12923514
    new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /hr$/),
    new HtmlPlugin({
      template: './src/index.ejs',
      inject: true,
      favicon: './src/favicon.ico',
      IS_PROD,
    }),
  ].concat(PLUGINS[env] || []),
  postcss: () => [
    autoprefixer,
  ],
  module: {
    loaders: [
      {
        test: /\.js$/,
        include: resolve('./src'),
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
        include: [resolve('./src/styles'), /flexboxgrid/],
        exclude: resolve('./src/styles/global'),
      },
      {
        test: /\.s?css$/,
        loader: STYLES_GLOBAL_LOADER[env],
        include: [resolve('./node_modules'), resolve('./src/styles/global')],
        exclude: [/flexboxgrid/],
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
  },
};
