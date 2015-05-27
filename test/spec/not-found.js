var client = require('../client');

describe('not found', function () {
  before(function () {
    return client.url('http://localhost:9000/non/existent');
  });

  it('displays the message', function () {
    return client.getText('h1').should.eventually.equal('Not Found!');
  });
});
