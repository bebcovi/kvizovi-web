import React from 'react';
import { render } from 'react-dom';
import App from './containers/App';
import 'elemental/less/elemental.less';

const rootEl = document.getElementById('root');

render(<App />, rootEl);
