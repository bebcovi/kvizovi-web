import test from 'ava';
import sinon from 'sinon';
import React from 'react';
import { shallow } from 'enzyme';
import { Question } from 'views/Question';

test('loads the question', t => {
  const actions = { loadQuestion: sinon.spy() };
  const params = { quizId: '1', questionId: '2' };
  shallow(<Question actions={actions} params={params} />);
  t.true(actions.loadQuestion.calledWith(params));
});

test('outputs attributes', t => {
  const wrapper = shallow(
    <Question
      actions={{ loadQuestion: () => {} }}
      params={{}}
      question={{ attributes: { title: 'foo' } }}
    />
  );
  t.regex(wrapper.render().text(), /foo/);
});
