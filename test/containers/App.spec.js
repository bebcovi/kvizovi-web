import test from 'ava';
import React from 'react';
import { shallow } from 'enzyme';
import App from 'containers/App';

test('greets the world', t => {
  const wrapper = shallow(<App />);
  t.regex(wrapper.render().text(), /hello world/i);
});
