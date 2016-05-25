/* eslint-disable no-constant-condition */
import { take, fork, put, call } from 'redux-saga/effects';
import * as actions from '../actions';
import { api } from '../services';

// subroutines

export function* fetchEntities(entities, apiFn) {
  yield put(entities.request());
  const { response, errors } = yield call(apiFn);
  if (response) {
    yield put(entities.success(response));
  } else {
    yield put(entities.failure(errors));
  }
}

export function* fetchEntity(entity, apiFn, payload) {
  yield put(entity.request(payload));
  const { response, errors } = yield call(apiFn, payload);
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

/* eslint-disable max-len */
export const fetchQuizzes = fetchEntities.bind(null, actions.fetchQuizzes, api.fetchQuizzes);
export const fetchQuiz = fetchEntity.bind(null, actions.fetchQuiz, api.fetchQuiz);
export const fetchQuizWithQuestions = fetchEntity.bind(null, actions.fetchQuizWithQuestions, api.fetchQuizWithQuestions);
export const updateQuiz = updateEntity.bind(null, actions.updateQuiz, api.updateQuiz);
export const fetchQuestion = fetchEntity.bind(null, actions.fetchQuestion, api.fetchQuestion);
/* eslint-enable */

export function* watchLoadDashboard() {
  while (true) {
    yield take(actions.LOAD_DASHBOARD);
    yield fork(fetchQuizzes);
  }
}

export function* watchLoadQuizzes() {
  while (true) {
    yield take(actions.LOAD_QUIZZES);
    yield fork(fetchQuizzes);
  }
}

export function* watchLoadQuiz() {
  while (true) {
    const { payload } = yield take(actions.LOAD_QUIZ);
    yield fork(fetchQuiz, payload);
  }
}

export function* watchLoadQuizWithQuestions() {
  while (true) {
    const { payload } = yield take(actions.LOAD_QUIZ_WITH_QUESTIONS);
    yield fork(fetchQuizWithQuestions, payload);
  }
}

export function* watchEditQuiz() {
  while (true) {
    const { payload } = yield take(actions.EDIT_QUIZ);
    yield fork(updateQuiz, payload);
  }
}

export function* watchLoadQuestion() {
  while (true) {
    const { payload } = yield take(actions.LOAD_QUESTION);
    yield fork(fetchQuestion, payload);
  }
}

export default function* rootSaga() {
  yield [
    fork(watchLoadDashboard),
    fork(watchLoadQuizzes),
    fork(watchLoadQuiz),
    fork(watchLoadQuizWithQuestions),
    fork(watchEditQuiz),
    fork(watchLoadQuestion),
  ];
}
