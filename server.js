const webpack = require('webpack');
const devMiddleware = require('webpack-dev-middleware');
const hotMiddleware = require('webpack-hot-middleware');
const historyApiFallback = require('connect-history-api-fallback');
const express = require('express');
const config = require('./webpack.config');
const debug = require('debug');

const app = express();
const compiler = webpack(config);
const debugHttp = debug('app:http');
const debugError = debug('app:error');

app.use(historyApiFallback({
  verbose: false,
}));

if (process.env.NODE_ENV === 'production') {
  app.use(express.static('dist'));
} else {
  app.use(devMiddleware(compiler, {
    noInfo: true,
    publicPath: config.output.publicPath,
    stats: {
      colors: true,
      chunks: false,
    },
  }));
  app.use(hotMiddleware(compiler));
}

const server = app.listen(9000, '0.0.0.0', (err) => {
  const HOST = server.address().address;
  const PORT = server.address().port;

  if (err) {
    debugError(err);
    return;
  }

  debugHttp('Listening at http://%s:%s', HOST, PORT);
});
