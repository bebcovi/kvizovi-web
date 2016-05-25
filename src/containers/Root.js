import React from 'react';
import { Router, Route, IndexRedirect } from 'react-router';
import { history } from '../services';

import App from '../views/App';
import Dashboard from '../views/Dashboard';
import Quizzes from '../views/Quizzes';
import Quiz from '../views/Quiz';
import Question from '../views/Question';
import NotFound from '../views/NotFound';

const Root = () => (
  <Router history={history}>
    <Route path="/" component={App}>
      <Route path="dashboard" component={Dashboard} />
      <Route path="quizzes" component={Quizzes} />
      <Route path="quizzes/:id" component={Quiz} />
      <Route path="quizzes/:quizId/questions/:questionId" component={Question} />
      <IndexRedirect to="dashboard" />
      <Route path="*" component={NotFound} />
    </Route>
  </Router>
);

export default Root;
