import test from 'ava';
import { put } from 'redux-saga/effects';
import * as actions from 'actions';
import * as sagas from 'sagas/dashboard';

test('loadDashboard() reports success', t => {
  const gen = sagas.loadDashboard();
  const response = {};
  gen.next(); // request
  gen.next(); // API call
  t.deepEqual(
    gen.next({ response }).value,
    put(actions.fetchQuizzes.success(response))
  );
});

test('loadDashboard() reports errors', t => {
  const gen = sagas.loadDashboard();
  const errors = {};
  gen.next(); // request
  gen.next(); // API call
  t.deepEqual(
    gen.next({ errors }).value,
    put(actions.fetchQuizzes.failure(errors))
  );
});
