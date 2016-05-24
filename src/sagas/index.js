/* eslint-disable no-constant-condition */
import { take, fork, put, call } from 'redux-saga/effects';
import * as actions from '../actions';
import { api } from '../services';

// subroutines

export function* fetchEntity(entity, apiFn) {
  yield put(entity.request());
  const { response, errors } = yield call(apiFn);
  if (response) {
    yield put(entity.success(response));
  } else {
    yield put(entity.failure(errors));
  }
}

export function* updateEntity(entity, apiFn, data) {
  yield put(entity.request(data));
  const { errors } = yield call(apiFn, data);
  if (errors) {
    yield put(entity.failure(errors));
  } else {
    yield put(entity.success(data));
  }
}

// now we can bind them

export const fetchQuizzes = fetchEntity.bind(null, actions.fetchQuizzes, api.fetchQuizzes);
export const updateQuiz = updateEntity.bind(null, actions.updateQuiz, api.updateQuiz);

export function* watchLoadDashboard() {
  while (true) {
    yield take(actions.LOAD_DASHBOARD);
    yield fork(fetchQuizzes);
  }
}

export function* watchEditQuiz() {
  while (true) {
    const { payload } = yield take(actions.EDIT_QUIZ);
    yield fork(updateQuiz, payload);
  }
}

export default function* rootSaga() {
  yield [
    fork(watchLoadDashboard),
    fork(watchEditQuiz),
  ];
}
