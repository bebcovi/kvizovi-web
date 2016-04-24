import { combineReducers } from 'redux';
import { routerReducer as routing } from 'react-router-redux';
import quizzes from './quizzes';

export default combineReducers({
  routing,
  quizzes,
});
