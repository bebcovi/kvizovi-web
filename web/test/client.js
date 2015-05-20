var chai = require('chai');
var chaiAsPromised = require('chai-as-promised');
var client = global.client;

if (client && client.requestHandler.sessionID) {
  module.exports = client;
} else {
  client = require('webdriverio').remote({
    logLevel: process.env.TRAVIS ? 'command' : 'silent',
    desiredCapabilities: {
      browserName: 'phantomjs'
    }
  });

  chai.use(chaiAsPromised);
  chai.should();
  chaiAsPromised.transferPromiseness = client.transferPromiseness;

  client.init();

  module.exports = client;
  global.client = client;
}
