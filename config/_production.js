import webpack from 'webpack';
import HtmlPlugin from 'html-webpack-plugin';
import ExtractTextPlugin from 'extract-text-webpack-plugin';
import { resolve } from 'path';
import queryString from 'query-string';
import { style } from './loaders';

const CSS_OPTIONS = queryString.stringify({
  modules: true,
  importLoaders: 1,
});

export default {
  resolve: {},
  entry: './src',
  output: {
    path: resolve('./dist'),
    filename: '[hash].js',
    publicPath: '/',
  },
  plugins: [
    new ExtractTextPlugin('[hash].css', { allChunks: true }),
    new HtmlPlugin({ template: './src/index.html' }),
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.optimize.UglifyJsPlugin({
      compressor: { warnings: false },
    }),
  ],
  module: {
    loaders: [
      Object.assign({ loader: ExtractTextPlugin.extract('style', `css?${CSS_OPTIONS}!postcss!sass`) }, style.modules),
      Object.assign({ loader: ExtractTextPlugin.extract('style', 'css?importLoaders=1!postcss!sass') }, style.global),
      { test: /\.(jpe?g|png|gif|svg)$/i, loader: 'url?limit=5000!image-webpack' },
    ],
  },
};
