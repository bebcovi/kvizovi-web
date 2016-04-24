import { takeLatest } from 'redux-saga';
import { call, put } from 'redux-saga/effects';
import * as Api from '../services/api';
import * as actions from '../actions';

const { quizzes } = actions;

export function* fetchQuizzes() {
  yield put(quizzes.request());
  const { response, errors } = yield call(Api.fetchQuizzes);
  if (response) {
    yield put(quizzes.success(response));
  } else {
    yield put(quizzes.failure(errors));
  }
}

export function* watchFetchQuizzes() {
  yield* takeLatest(actions.FETCH_QUIZZES.REQUEST, fetchQuizzes);
}
