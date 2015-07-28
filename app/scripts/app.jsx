import React from 'react/addons';
import Router from 'react-router';

import Navigation from './components/navigation';
import Quizzes from './views/quizzes';
import Quiz from './views/quiz';
import Register from './views/register';
import Profile from './views/profile';
import NotFound from './views/not-found';

import './vendor/materialize';
import './fonts';
import './tap';

const {
  Route,
  Redirect,
  NotFoundRoute,
  RouteHandler
} = Router;

const App = React.createClass({
  render() {
    return (
      <div>
        <Navigation />
        <RouteHandler />
      </div>
    );
  }
});

const routes = (
  <Route path="/" handler={App}>
    <Redirect from="/" to="/quizzes" />
    <Route path="quizzes" handler={Quizzes} />
    <Route path="quizzes/:id" handler={Quiz} />
    <Route path="register" handler={Register} />
    <Route path="profile" handler={Profile} />
    <NotFoundRoute handler={NotFound} />
  </Route>
);

Router.run(routes, Router.HistoryLocation, Handler => {
  React.render(<Handler />, document.getElementById('content'));
});
