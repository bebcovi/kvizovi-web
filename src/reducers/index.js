import { combineReducers } from 'redux';
import { routerReducer as routing } from 'react-router-redux';
import quizzes from './quizzes';
import entities from './entities';

export default combineReducers({
  routing,
  quizzes,
  entities,
});
