import test from 'ava';
import React from 'react';
import { shallow } from 'enzyme';
import { NotFound } from 'views/NotFound';

test('renders the warning', t => {
  const wrapper = shallow(<NotFound />);
  t.regex(wrapper.render().text(), /404/);
});
