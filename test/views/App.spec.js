import test from 'ava';
import React from 'react';
import { shallow } from 'enzyme';
import { App } from 'views/App';

test('renders children', t => {
  const child = <div>{'child'}</div>;
  const wrapper = shallow(<App>{child}</App>);
  t.true(wrapper.contains(child));
});
