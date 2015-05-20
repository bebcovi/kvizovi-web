var chai = require('chai');
var chaiAsPromised = require('chai-as-promised');
var client = require('webdriverio').remote({
  desiredCapabilities: {
    browserName: 'phantomjs'
  }
});

chai.use(chaiAsPromised);
chai.should();
chaiAsPromised.transferPromiseness = client.transferPromiseness;

module.exports = client;
