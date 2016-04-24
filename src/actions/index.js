const REQUEST = 'REQUEST';
const SUCCESS = 'SUCCESS';
const FAILURE = 'FAILURE';

function createRequestTypes(base) {
  const res = {};
  [REQUEST, SUCCESS, FAILURE].forEach(type => {
    res[type] = `${base}_${type}`;
  });
  return res;
}

export const FETCH_QUIZZES = createRequestTypes('FETCH_QUIZZES');

function action(type, payload) {
  return Object.assign({ type }, payload);
}

export const quizzes = {
  request: () => action(FETCH_QUIZZES.REQUEST),
  success: response => action(FETCH_QUIZZES.SUCCESS, { response }),
  failure: errors => action(FETCH_QUIZZES.FAILURE, { errors }),
};
