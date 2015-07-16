import React from 'react/addons';
import Router from 'react-router';
import Home from './views/home';
import NotFound from './views/not-found';

import './fonts';
import 'svg4everybody';

const {
  Route,
  DefaultRoute,
  NotFoundRoute,
  RouteHandler
} = Router;

const App = React.createClass({
  render() {
    return <RouteHandler />;
  }
});

const routes = (
  <Route name="app" path="/" handler={App}>
    <DefaultRoute handler={Home} />
    <NotFoundRoute handler={NotFound} />
  </Route>
);

Router.run(routes, Router.HistoryLocation, Handler => {
  React.render(<Handler />, document.getElementById('content'));
});
