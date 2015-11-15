import webpack from 'webpack';
import { resolve } from 'path';
import autoprefixer from 'autoprefixer';

export default {
  resolve: {
    extensions: ['', '.webpack.js', '.web.js', '.js', '.scss'],
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV),
      __API_URL__: JSON.stringify(process.env.NODE_ENV === 'production' ?
        'http://api.kvizovi.org' :
        'http://localhost:3000'),
      __DEV__: JSON.stringify(process.env.NODE_ENV === 'development' || !process.env.NODE_ENV),
      __TEST__: JSON.stringify(process.env.NODE_ENV === 'test'),
      __PROD__: JSON.stringify(process.env.NODE_ENV === 'production'),
    }),
    // https://github.com/webpack/webpack/issues/59#issuecomment-12923514
    new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /hr$/),
  ],
  module: {
    loaders: [
      { test: /\.js$/, loader: 'babel', include: [resolve('./src'), resolve('./test')] },
      { loader: 'file?name=[name].[ext]', include: resolve('./static') },
    ],
  },
  postcss: () => [
    autoprefixer,
  ],
};
