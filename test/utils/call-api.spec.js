import test from 'ava';
import nock from 'nock';
import { Schema } from 'normalizr';
import callApi from 'utils/call-api';

test('camelizes response', t => {
  nock(__API_URL__)
    .get('/foo')
    .reply(200, { foo_bar: 'foo bar' });
  return callApi('foo').then(({ response }) => {
    t.deepEqual(response, { fooBar: 'foo bar' });
  });
});

test.skip('handles response-less requests', t => {
  nock(__API_URL__)
    .get('/foo')
    .reply(200);
  return callApi('foo').then(({ errors }) => {
    t.ifError(errors);
  });
});

test('returns errors', t => {
  nock(__API_URL__)
    .get('/foo')
    .reply(500, { errors: { foo: 'bar' } });
  return callApi('foo').then(({ errors }) => {
    t.deepEqual(errors, { foo: 'bar' });
  });
});

test('uses the HTTP method', t => {
  nock(__API_URL__)
    .post('/foo')
    .reply(200, { foo: 'bar' });
  return callApi('foo', null, 'post').then(({ response }) => {
    t.deepEqual(response, { foo: 'bar' });
  });
});

test('decamelizes body', t => {
  nock(__API_URL__)
    .patch('/foo', { foo_bar: 'foo bar' })
    .reply(200, { foo: 'bar' });
  return callApi('foo', null, 'patch', { fooBar: 'foo bar' }).then(({ response }) => {
    t.deepEqual(response, { foo: 'bar' });
  });
});

test('normalizes the response', t => {
  const schema = new Schema('quizzes');
  nock(__API_URL__)
    .get('/quizzes')
    .reply(200, { id: 1, name: 'foo' });
  return callApi('quizzes', schema).then(({ response }) => {
    t.deepEqual(response, {
      result: 1,
      entities: {
        quizzes: {
          1: { id: 1, name: 'foo' },
        },
      },
    });
  });
});

test.after(() => {
  nock.restore();
});
