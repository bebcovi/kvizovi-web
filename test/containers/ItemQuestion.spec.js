import test from 'ava';
import React from 'react';
import { shallow } from 'enzyme';
import ItemQuestion from 'containers/ItemQuestion';
import { Link } from 'react-router';

test('outputs the title and link', t => {
  const wrapper = shallow(<ItemQuestion id="2" quizId="1" title="foo" />);
  t.regex(wrapper.render().text(), /foo/);
});

test('generates the link', t => {
  const wrapper = shallow(<ItemQuestion id="2" quizId="1" title="foo" />);
  t.regex(wrapper.find(Link).prop('to'), /quizzes\/1\/questions\/2/);
});
