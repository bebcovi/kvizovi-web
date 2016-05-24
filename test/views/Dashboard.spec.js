import test from 'ava';
import sinon from 'sinon';
import React from 'react';
import { shallow } from 'enzyme';
import { Dashboard } from 'views/Dashboard';
import ItemQuizForm from 'containers/ItemQuizForm';

test('greets the world', t => {
  const wrapper = shallow(<Dashboard actions={{}} quizzes={[]} />);
  t.regex(wrapper.render().text(), /hello world/i);
});

test('loads quizzes', t => {
  const actions = { loadDashboard: sinon.spy() };
  const wrapper = shallow(<Dashboard actions={actions} quizzes={[]} />);
  wrapper.find('button').simulate('click');
  t.true(actions.loadDashboard.calledOnce);
});

test('displays quizzes', t => {
  const actions = { openQuizForm: () => {} };
  const quizzes = [
    { id: '1', attributes: { name: 'foo' } },
    { id: '2', attributes: { name: 'bar' } },
  ];
  const wrapper = shallow(<Dashboard actions={actions} quizzes={quizzes} />);
  t.regex(wrapper.render().text(), /foo/);
  t.regex(wrapper.render().text(), /bar/);
});

test('displays quiz form', t => {
  const actions = { openQuizForm: () => {} };
  const quizzes = [
    { id: '1', attributes: { name: 'foo' } },
    { id: '2', attributes: { name: 'bar' } },
  ];
  const wrapper = shallow(<Dashboard actions={actions} quizzes={quizzes} editQuizId="1" />);
  t.truthy(wrapper.find('li').first().find(ItemQuizForm).length);
});
