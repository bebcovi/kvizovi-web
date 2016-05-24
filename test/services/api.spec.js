import test from 'ava';
import nock from 'nock';
import { api } from 'services';

test('fetchQuizzes', t => {
  nock(__API_URL__)
    .get('/quizzes')
    .reply(200, {
      data: [
        { id: '1' },
        { id: '2' },
      ],
    });
  return api.fetchQuizzes().then(({ response }) => {
    t.deepEqual(response.result, { data: ['1', '2'] });
  });
});

test.skip('updateQuiz', t => {
  const data = { id: '1' };
  nock(__API_URL__)
    .patch('/quizzes/1', { data })
    .reply(200);
  return api.updateQuiz(data).then(({ errors }) => {
    t.ifError(errors);
  });
});
