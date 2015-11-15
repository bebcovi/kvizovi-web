import { resolve } from 'path';
import queryString from 'query-string';
import { style } from './loaders';

const CSS_OPTIONS = queryString.stringify({
  modules: true,
  localIdentName: '[name]__[local]',
});

export default {
  resolve: { root: resolve('./src') },
  devtool: 'cheap-source-map',
  target: 'node',
  entry: './test',
  output: {
    path: resolve('./.tmp'),
    filename: 'test.js',
    publicPath: '/',
  },
  plugins: [],
  module: {
    // isomorphic-fetch fix
    // https://github.com/webpack/webpack/issues/198#issuecomment-37306725
    // require(expr)
    exprContextRegExp: /$^/,
    exprContextCritical: false,
    loaders: [
      Object.assign({ loader: `style!css?${CSS_OPTIONS}!sass` }, style.modules),
      Object.assign({ loader: 'style!css!sass' }, style.global),
      { test: /\.(jpe?g|png|gif|svg)$/, loaders: ['null'] },
    ],
  },
};
