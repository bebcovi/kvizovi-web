import { combineReducers } from 'redux';
import { routerReducer as routing } from 'react-router-redux';
import { reducer as form } from 'redux-form';
import quizzes from './quizzes';
import entities from './entities';

export default combineReducers({
  routing,
  form,
  quizzes,
  entities,
});
