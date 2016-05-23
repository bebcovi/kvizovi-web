import React from 'react';
import { render } from 'react-dom';
import App from './containers/App';

const rootEl = document.getElementById('root');

render(<App />, rootEl);

if (module.hot) {
  module.hot.accept('./containers/App', () => {
    const NextApp = require('./containers/App').default;
    render(<NextApp />, rootEl);
  });
}
