import { take, put, fork, call } from 'redux-saga/effects';
import { api } from '../services';
import * as actions from '../actions';

export function* loadDashboard() {
  yield put(actions.fetchQuizzes.request());
  const { response, errors } = yield call(api.fetchQuizzes);
  if (response) {
    yield put(actions.fetchQuizzes.success(response));
  } else {
    yield put(actions.fetchQuizzes.failure(errors));
  }
}

export function* watchLoadDashboard() {
  while (true) {
    yield take(actions.LOAD_DASHBOARD);
    yield fork(loadDashboard);
  }
}
