import React, { PropTypes } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import style from '../styles/App.scss';
import { loadDashboard } from '../actions';

const App = props => (
  <div className={style.container}>
    <h1>{'Hello World!'}</h1>
    <button
      type="button"
      onClick={props.actions.loadDashboard}
    >
      {'Load dashboard'}
    </button>
    <ul>
      {props.quizzes.map(quiz => (
        <li key={quiz.id}>
          {quiz.attributes.name}
        </li>
      ))}
    </ul>
  </div>
);

App.propTypes = {
  actions: PropTypes.object.isRequired,
  quizzes: PropTypes.array.isRequired,
};

function mapStateToProps(state) {
  return {
    quizzes: state.quizzes.ids.map(id => state.entities.quizzes[id]),
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators({
      loadDashboard,
    }, dispatch),
  };
}

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(App);
