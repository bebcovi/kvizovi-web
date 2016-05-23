import { FETCH_QUIZZES } from '../actions';

const initialState = {
  ids: [],
};

export default function reducer(state = initialState, action) {
  switch (action.type) {
    case FETCH_QUIZZES.SUCCESS:
      return { ...state, ids: action.payload.result.data };

    default:
      return state;
  }
}
