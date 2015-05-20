import React    from 'react';
import Router   from 'react-router';

// views

import Home     from './views/home';
import NotFound from './views/not-found';

// polyfills

import './fonts';
import 'svg4everybody';

var {
  Route,
  DefaultRoute,
  NotFoundRoute,
  RouteHandler
} = Router;

var App = React.createClass({
  render() {
    return <RouteHandler />;
  }
});

var routes = (
  <Route name="app" path="/" handler={App}>
    <DefaultRoute handler={Home} />
    <NotFoundRoute handler={NotFound} />
  </Route>
);

Router.run(routes, Router.HistoryLocation, function (Handler) {
  React.render(<Handler />, document.body);
});
