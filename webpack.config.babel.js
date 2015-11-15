import config from './config';

const env = process.env.NODE_ENV || 'development';

export default Object.assign(config.base, config[env], {
  plugins: Object.assign(config.base.plugins, config[env].plugins),
  module: Object.assign(config.base.module, config[env].module, {
    loaders: [].concat(config.base.module.loaders, config[env].module.loaders),
  }),
});
