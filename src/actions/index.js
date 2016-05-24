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

function action(type, payload) {
  return (
    payload &&
    payload.constructor.name !== 'SyntheticMouseEvent'
  ) ? { type, payload } : { type };
}

function createAction(type) {
  return payload => action(type, payload);
}

function createActionsFromTypes(types) {
  const res = {};
  Reflect.ownKeys(types).forEach(type => {
    res[type.toLowerCase()] = createAction(types[type]);
  });
  return res;
}

export const LOAD_DASHBOARD = 'LOAD_DASHBOARD';
export const OPEN_QUIZ_FORM = 'OPEN_QUIZ_FORM';
export const EDIT_QUIZ = 'EDIT_QUIZ';

export const FETCH_QUIZZES = createRequestTypes('FETCH_QUIZZES');
export const UPDATE_QUIZ = createRequestTypes('UPDATE_QUIZ');

export const loadDashboard = createAction(LOAD_DASHBOARD);
export const openQuizForm = createAction(OPEN_QUIZ_FORM);
export const editQuiz = createAction(EDIT_QUIZ);

export const fetchQuizzes = createActionsFromTypes(FETCH_QUIZZES);
export const updateQuiz = createActionsFromTypes(UPDATE_QUIZ);
