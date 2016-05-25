import test from 'ava';
import sinon from 'sinon';
import React from 'react';
import { shallow } from 'enzyme';
import { Quiz } from 'views/Quiz';

test('loads the quiz with questions', t => {
  const actions = { loadQuizWithQuestions: sinon.spy() };
  shallow(<Quiz actions={actions} params={{ id: '1' }} />);
  t.true(actions.loadQuizWithQuestions.calledWith('1'));
});

test('outputs attributes', t => {
  const actions = { loadQuizWithQuestions: () => {} };
  const wrapper = shallow(
    <Quiz
      actions={actions}
      params={{ id: '1' }}
      quiz={{ attributes: { name: 'foo' } }}
    />
  );
  t.regex(wrapper.render().text(), /foo/);
});

test('lists questions', t => {
  const actions = { loadQuizWithQuestions: () => {} };
  const wrapper = shallow(
    <Quiz
      actions={actions}
      params={{ id: '1' }}
      quiz={{ attributes: {} }}
      questions={[{ id: '2', attributes: { title: 'foo' } }]}
    />
  );
  t.regex(wrapper.render().text(), /foo/);
});
