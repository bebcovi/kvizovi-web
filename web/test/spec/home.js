var client = require('../client');

describe('home', function () {
  before(function () {
    return client.url('http://localhost:9000');
  });

  it('greets the world', function () {
    return client.getText('h1').should.eventually.equal('Hello World!');
  });
});
