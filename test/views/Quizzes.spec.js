import test from 'ava';
import sinon from 'sinon';
import React from 'react';
import { shallow } from 'enzyme';
import { Quizzes } from 'views/Quizzes';

test('loads quizzes', t => {
  const actions = { loadQuizzes: sinon.spy() };
  shallow(<Quizzes actions={actions} />);
  t.true(actions.loadQuizzes.calledOnce);
});

test('lists quizzes', t => {
  const actions = { loadQuizzes: () => {} };
  const wrapper = shallow(
    <Quizzes
      actions={actions}
      quizzes={[{ id: '1', attributes: { name: 'foo' } }]}
    />
  );
  t.regex(wrapper.render().text(), /foo/);
});
