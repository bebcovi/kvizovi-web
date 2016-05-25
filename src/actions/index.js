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
export const LOAD_QUIZZES = 'LOAD_QUIZZES';
export const LOAD_QUIZ = 'LOAD_QUIZ';
export const LOAD_QUIZ_WITH_QUESTIONS = 'LOAD_QUIZ_WITH_QUESTIONS';
export const EDIT_QUIZ = 'EDIT_QUIZ';
export const LOAD_QUESTION = 'LOAD_QUESTION';

export const loadDashboard = createAction(LOAD_DASHBOARD);
export const openQuizForm = createAction(OPEN_QUIZ_FORM);
export const loadQuizzes = createAction(LOAD_QUIZZES);
export const loadQuiz = createAction(LOAD_QUIZ);
export const loadQuizWithQuestions = createAction(LOAD_QUIZ_WITH_QUESTIONS);
export const editQuiz = createAction(EDIT_QUIZ);
export const loadQuestion = createAction(LOAD_QUESTION);

export const FETCH_QUIZZES = createRequestTypes('FETCH_QUIZZES');
export const FETCH_QUIZ = createRequestTypes('FETCH_QUIZ');
export const FETCH_QUIZ_WITH_QUESTIONS = createRequestTypes('FETCH_QUIZ_WITH_QUESTIONS');
export const UPDATE_QUIZ = createRequestTypes('UPDATE_QUIZ');
export const FETCH_QUESTION = createRequestTypes('FETCH_QUESTION');

export const fetchQuizzes = createActionsFromTypes(FETCH_QUIZZES);
export const fetchQuiz = createActionsFromTypes(FETCH_QUIZ);
export const fetchQuizWithQuestions = createActionsFromTypes(FETCH_QUIZ_WITH_QUESTIONS);
export const updateQuiz = createActionsFromTypes(UPDATE_QUIZ);
export const fetchQuestion = createActionsFromTypes(FETCH_QUESTION);
