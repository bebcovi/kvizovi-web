var client = require ('./support/common');

describe('home', function () {
  before(function () {
    return client.init().url('http://localhost:9000');
  });

  it('greets the world', function () {
    return client.getText('h1').should.eventually.equal('Hello World!');
  });

  after(function () {
    return client.end();
  });
});
