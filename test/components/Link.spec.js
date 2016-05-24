import test from 'ava';
import sinon from 'sinon';
import React from 'react';
import { shallow } from 'enzyme';
import Link from 'components/Link';

test('renders children', t => {
  const child = <div>{'child'}</div>;
  const wrapper = shallow(<Link>{child}</Link>);
  t.true(wrapper.contains(child));
});

test('prevents default and calls onClick', t => {
  const event = { preventDefault: sinon.spy() };
  const handler = sinon.spy();
  const wrapper = shallow(<Link onClick={handler} />);
  wrapper.simulate('click', event);
  t.true(event.preventDefault.calledOnce);
  t.true(handler.calledOnce);
});

test('passes rest of the props to <a>', t => {
  const wrapper = shallow(<Link foo="bar" />);
  t.is(wrapper.find('a').prop('foo'), 'bar');
});
