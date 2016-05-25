import test from 'ava';
import nock from 'nock';
import { api } from 'services';

test('fetchQuizzes', t => {
  nock(__API_URL__)
    .get('/quizzes')
    .reply(200, { data: [{ id: '1' }] });
  return api.fetchQuizzes().then(({ response }) => {
    t.deepEqual(response.result, { data: ['1'] });
  });
});

test('fetchQuiz', t => {
  nock(__API_URL__)
    .get('/quizzes/1')
    .reply(200, { data: { id: '1' } });
  return api.fetchQuiz('1').then(({ response }) => {
    t.deepEqual(response.result, { data: '1' });
  });
});

test('fetchQuizWithQuestions', t => {
  nock(__API_URL__)
    .get('/quizzes/1')
    .query({ include: 'questions' })
    .reply(200, {
      data: { id: '1' },
      included: [{ id: '2' }],
    });
  return api.fetchQuizWithQuestions('1').then(({ response }) => {
    t.deepEqual(response.result, {
      data: '1',
      included: ['2'],
    });
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

test('fetchQuestions', t => {
  nock(__API_URL__)
    .get('/quizzes/1/questions')
    .reply(200, { data: [{ id: '1' }] });
  return api.fetchQuestions(1).then(({ response }) => {
    t.deepEqual(response.result, { data: ['1'] });
  });
});

test('fetchQuestion', t => {
  nock(__API_URL__)
    .get('/quizzes/1/questions/2')
    .reply(200, { data: { id: '2' } });
  return api.fetchQuestion({ quizId: '1', questionId: '2' }).then(({ response }) => {
    t.deepEqual(response.result, { data: '2' });
  });
});

test.after('restore HTTP interceptors', () => {
  nock.restore();
});
