import { createStore, applyMiddleware } from 'redux';
import createSagaMiddleware from 'redux-saga';
import rootReducer from '../reducers';
import rootSaga from '../sagas';
import createLogger from 'redux-logger';

export default function configureStore(initialState) {
  const sagaMiddleware = createSagaMiddleware(rootSaga);
  let enhancer = applyMiddleware(
    sagaMiddleware
  );

  if (__DEV__) {
    enhancer = applyMiddleware(
      sagaMiddleware,
      createLogger()
    );
  }

  const store = createStore(
    rootReducer,
    initialState,
    enhancer
  );

  if (__DEV__ && module.hot) {
    // Enable Webpack hot module replacement for reducers
    module.hot.accept('../reducers', () => {
      const nextRootReducer = require('../reducers').default; // eslint-disable-line global-require
      store.replaceReducer(nextRootReducer);
    });
  }

  return store;
}
