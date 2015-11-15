import webpack from 'webpack';
import devMiddleware from 'webpack-dev-middleware';
import hotMiddleware from 'webpack-hot-middleware';
import historyApiFallback from 'connect-history-api-fallback';
import express from 'express';
import config from './webpack.config.babel';
import _debug from 'debug';

const app = express();
const compiler = webpack(config);
const debug = _debug('app:http');
const error = _debug('app:error');

app.use(historyApiFallback({
  verbose: false,
}));
app.use(devMiddleware(compiler, {
  noInfo: true,
  publicPath: config.output.publicPath,
  stats: {
    colors: true,
    chunks: false,
  },
}));
app.use(hotMiddleware(compiler));

const server = app.listen(9000, 'localhost', (err) => {
  const HOST = server.address().address;
  const PORT = server.address().port;

  if (err) {
    error(err);
    return;
  }

  debug('Listening at http://%s:%s', HOST, PORT);
});
