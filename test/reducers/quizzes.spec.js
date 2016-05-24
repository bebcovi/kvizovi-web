import test from 'ava';
import reducer from 'reducers/quizzes';
import { FETCH_QUIZZES, OPEN_QUIZ_FORM, EDIT_QUIZ } from 'actions';

test('saves fetched quizzes', t => {
  const result = { data: ['1', '2'] };
  const state = reducer(undefined, {
    type: FETCH_QUIZZES.SUCCESS,
    payload: { result },
  });
  t.deepEqual(state.ids, result.data);
});

test('manages the editing item', t => {
  let state = reducer(undefined, { type: OPEN_QUIZ_FORM, payload: '1' });
  t.is(state.editId, '1');
  state = reducer(state, { type: EDIT_QUIZ.SUCCESS });
  t.falsy(state.editId);
});
