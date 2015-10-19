import React from 'react/addons';
import Router from 'react-router';
import Quizzes from './views/quizzes';
import Quiz from './views/quiz';
import Register from './views/register';
import Styleguide from './views/styleguide';
import StyleguideButtons from './views/styleguide/buttons';
import StyleguideForms from './views/styleguide/forms';
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
    return <RouteHandler />;
  }
});

const routes = (
  <Route path="/" handler={App}>
    <Redirect from="/" to="/quizzes" />
    <Route path="quizzes" handler={Quizzes} />
    <Route path="quizzes/:id" handler={Quiz} />
    <Route path="register" handler={Register} />
    <Route path="styleguide" handler={Styleguide}>
      <Route path="buttons" handler={StyleguideButtons} />
      <Route path="forms" handler={StyleguideForms} />
    </Route>
    <NotFoundRoute handler={NotFound} />
  </Route>
);

Router.run(routes, Router.HistoryLocation, Handler => {
  React.render(<Handler />, document.getElementById('content'));
});
