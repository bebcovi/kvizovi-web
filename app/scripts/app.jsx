import React from 'react/addons';
import Router from 'react-router';
import Quizzes from './views/quizzes';
import Quiz from './views/quiz';
import Register from './views/register';
import NotFound from './views/not-found';

import './fonts';
import 'svg4everybody';

const {
  Route,
  Redirect,
  NotFoundRoute,
  RouteHandler
} = Router;

const App = React.createClass({
  render() {
    return (
      <main className="main">
        <RouteHandler />
      </main>
    );
  }
});

const routes = (
  <Route path="/" handler={App}>
    <Redirect from="/" to="/quizzes" />
    <Route path="quizzes" handler={Quizzes} />
    <Route path="quizzes/:id" handler={Quiz} />
    <Route path="register" handler={Register} />
    <NotFoundRoute handler={NotFound} />
  </Route>
);

Router.run(routes, Router.HistoryLocation, Handler => {
  React.render(<Handler />, document.getElementById('content'));
});
