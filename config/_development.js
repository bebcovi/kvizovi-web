import webpack from 'webpack';
import HtmlPlugin from 'html-webpack-plugin';
import { resolve } from 'path';
import queryString from 'query-string';
import { style } from './loaders';

const CSS_OPTIONS = queryString.stringify({
  modules: true,
  localIdentName: '[name]__[local]___[hash:base64:5]',
  importLoaders: 1,
});

export default {
  resolve: {},
  devtool: 'cheap-module-eval-source-map',
  entry: [
    'webpack-hot-middleware/client',
    './src',
  ],
  output: {
    path: resolve('./dist'),
    filename: 'bundle.js',
    publicPath: '/',
  },
  plugins: [
    new HtmlPlugin({ template: './src/index.html' }),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin(),
  ],
  module: {
    loaders: [
      Object.assign({ loader: `style!css?${CSS_OPTIONS}!postcss!sass` }, style.modules),
      Object.assign({ loader: 'style!css?importLoaders=1!postcss!sass' }, style.global),
      { test: /\.(jpe?g|png|gif|svg)$/i, loader: 'url?limit=10000&name=[name].[ext]' },
    ],
  },
};
