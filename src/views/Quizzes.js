import React, { PropTypes } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import ItemQuiz from '../containers/ItemQuiz';
import { loadQuizzes } from '../actions';

export class Quizzes extends React.Component {
  componentWillMount() {
    this.props.actions.loadQuizzes();
  }

  render() {
    return (
      <div>
        <h1>{'Kvizovi'}</h1>
        <ol>
          {this.props.quizzes && this.props.quizzes.map(quiz => (
            <li key={quiz.id}>
              <ItemQuiz
                id={quiz.id}
                {...quiz.attributes}
              />
            </li>
          ))}
        </ol>
      </div>
    );
  }
}

Quizzes.propTypes = {
  actions: PropTypes.object.isRequired,
  quizzes: PropTypes.array,
};

function mapStateToProps(state) {
  return {
    quizzes: state.quizzes.ids.map(id => state.entities.quizzes[id]),
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators({
      loadQuizzes,
    }, dispatch),
  };
}

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Quizzes);
