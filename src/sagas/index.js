import { fork } from 'redux-saga/effects';
import { watchLoadDashboard } from './dashboard';

export default function* rootSaga() {
  yield [
    fork(watchLoadDashboard),
  ];
}
