import React, { PropTypes } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import ItemQuiz from '../containers/ItemQuiz';
import ItemQuizForm from '../containers/ItemQuizForm';
import style from '../styles/Dashboard.scss';
import { loadDashboard, openQuizForm, editQuiz } from '../actions';

export const Dashboard = props => (
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
          {props.editQuizId === quiz.id ? (
            <ItemQuizForm
              initialValues={quiz}
              onSubmit={props.actions.editQuiz}
            />
          ) : (
            <ItemQuiz
              {...quiz}
              onEdit={props.actions.openQuizForm}
            />
          )}
        </li>
      ))}
    </ul>
  </div>
);

Dashboard.propTypes = {
  actions: PropTypes.object.isRequired,
  quizzes: PropTypes.array.isRequired,
  editQuizId: PropTypes.string,
};

function mapStateToProps(state) {
  return {
    quizzes: state.quizzes.ids.map(id => state.entities.quizzes[id]),
    editQuizId: state.quizzes.editId,
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators({
      loadDashboard,
      openQuizForm,
      editQuiz,
    }, dispatch),
  };
}

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Dashboard);
