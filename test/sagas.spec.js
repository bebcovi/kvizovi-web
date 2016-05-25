import test from 'ava';
import { put, call } from 'redux-saga/effects';
import * as sagas from 'sagas';
import * as actions from 'actions';
import { api } from 'services';

test('fetchEntities reports success', t => {
  const gen = sagas.fetchEntities(actions.fetchQuizzes, api.fetchQuizzes);
  const response = {};
  t.deepEqual(
    gen.next().value,
    put(actions.fetchQuizzes.request())
  );
  t.deepEqual(
    gen.next().value,
    call(api.fetchQuizzes)
  );
  t.deepEqual(
    gen.next({ response }).value,
    put(actions.fetchQuizzes.success(response))
  );
});

test('fetchEntities reports failure', t => {
  const gen = sagas.fetchEntities(actions.fetchQuizzes, api.fetchQuizzes);
  const errors = {};
  gen.next(); // request
  gen.next(); // API call
  t.deepEqual(
    gen.next({ errors }).value,
    put(actions.fetchQuizzes.failure(errors))
  );
});

test('fetchEntity takes API payload', t => {
  const gen = sagas.fetchEntity(actions.fetchQuiz, api.fetchQuiz, '1');
  const response = {};
  t.deepEqual(
    gen.next().value,
    put(actions.fetchQuiz.request('1'))
  );
  t.deepEqual(
    gen.next().value,
    call(api.fetchQuiz, '1')
  );
  t.deepEqual(
    gen.next({ response }).value,
    put(actions.fetchQuiz.success(response))
  );
});

test('updateEntity reports success', t => {
  const data = { foo: 'bar' };
  const gen = sagas.updateEntity(actions.updateQuiz, api.updateQuiz, data);
  t.deepEqual(
    gen.next().value,
    put(actions.updateQuiz.request(data))
  );
  t.deepEqual(
    gen.next().value,
    call(api.updateQuiz, data)
  );
  t.deepEqual(
    gen.next({}).value,
    put(actions.updateQuiz.success(data))
  );
});

test('updateEntity reports failure', t => {
  const data = { foo: 'bar' };
  const gen = sagas.updateEntity(actions.updateQuiz, api.updateQuiz, data);
  const errors = {};
  gen.next(); // request
  gen.next(); // API call
  t.deepEqual(
    gen.next({ errors }).value,
    put(actions.updateQuiz.failure(errors))
  );
});
