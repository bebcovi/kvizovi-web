import React from 'react';
import { Provider } from 'react-redux';
import { render } from 'react-dom';
import moment from 'moment';
import Root from './containers/Root';
import configureStore from './configureStore';
import './styles/global/base.scss';

const store = configureStore();
const rootEl = document.getElementById('root');

moment.locale('hr');

render(
  <Provider store={store}>
    <Root />
  </Provider>,
  rootEl
);

if (module.hot) {
  module.hot.accept('./containers/Root', () => {
    const NextRoot = require('./containers/Root').default;
    render(
      <Provider store={store}>
        <NextRoot />
      </Provider>,
      rootEl
    );
  });
}
