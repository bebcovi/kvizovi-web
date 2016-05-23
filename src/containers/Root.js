import React from 'react';
import { Router, Route, IndexRedirect } from 'react-router';
import { history } from '../services';
import App from '../views/App';
import Dashboard from '../views/Dashboard';
import NotFound from '../views/NotFound';

const Root = () => (
  <Router history={history}>
    <Route path="/" component={App}>
      <Route path="dashboard" component={Dashboard} />
      <IndexRedirect to="dashboard" />
      <Route path="*" component={NotFound} />
    </Route>
  </Router>
);

export default Root;
