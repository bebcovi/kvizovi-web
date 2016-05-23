const webpack = require('webpack');
const WebpackDevServer = require('webpack-dev-server');
const config = require('./webpack.config');
const debug = require('debug');

const log = debug('app:http');
const error = debug('app:error');

new WebpackDevServer(webpack(config), { // eslint-disable-line no-new
  publicPath: config.output.publicPath,
  noInfo: true,
  hot: true,
  historyApiFallback: true,
}).listen(9000, '0.0.0.0', (err) => {
  if (err) {
    error(err);
  } else {
    log('Listening at http://0.0.0.0:9000');
  }
});
