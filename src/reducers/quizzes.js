import { FETCH_QUIZZES, OPEN_QUIZ_FORM, EDIT_QUIZ } from '../actions';

const initialState = {
  ids: [],
  editId: undefined,
};

export default function reducer(state = initialState, action) {
  switch (action.type) {
    case FETCH_QUIZZES.SUCCESS:
      return { ...state, ids: action.payload.result.data };

    case OPEN_QUIZ_FORM:
      return { ...state, editId: action.payload };

    case EDIT_QUIZ.SUCCESS:
      return { ...state, editId: undefined };

    default:
      return state;
  }
}
