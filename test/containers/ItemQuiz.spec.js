import test from 'ava';
import sinon from 'sinon';
import React from 'react';
import { shallow } from 'enzyme';
import { ItemQuiz } from 'containers/ItemQuiz';

test('outputs name', t => {
  const wrapper = shallow(
    <ItemQuiz id="1" name="foo" />
  );
  t.regex(wrapper.render().text(), /foo/);
});

test('calls onEdit', t => {
  const onEdit = sinon.spy();
  const wrapper = shallow(
    <ItemQuiz id="1" name="" onEdit={onEdit} />
  );
  wrapper.find('button').simulate('click');
  t.true(onEdit.calledWith('1'));
});
