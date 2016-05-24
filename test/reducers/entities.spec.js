import test from 'ava';
import reducer from 'reducers/entities';

test('collects entities', t => {
  const entities = {
    quizzes: {
      1: { id: '1' },
      2: { id: '2' },
    },
  };
  const state = reducer(undefined, { type: 'ANY', payload: { entities } });
  t.deepEqual(state.quizzes, entities.quizzes);
});
