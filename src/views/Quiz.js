import React, { PropTypes } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import ItemQuestion from '../containers/ItemQuestion';
import { loadQuizWithQuestions } from '../actions';
import moment from 'moment';

export class Quiz extends React.Component {
  componentWillMount() {
    this.props.actions.loadQuizWithQuestions(this.props.params.id);
  }

  render() {
    const { quiz } = this.props;
    return (
      <div>
        {quiz && (
          <div>
            <h1>{quiz.attributes.name}</h1>
            <div>{'Zadnje ažurirano: '}{moment(quiz.updatedAt).format('Do MMMM YYYY')}</div>
            <div>{'Kategorija: '}{quiz.attributes.category}</div>
            <ol>
              {this.props.questions && this.props.questions.map(question => (
                <li key={question.id}>
                  <ItemQuestion
                    id={question.id}
                    quizId={this.props.params.id}
                    {...question.attributes}
                  />
                </li>
              ))}
            </ol>
          </div>
        )}
      </div>
    );
  }
}

Quiz.propTypes = {
  actions: PropTypes.object.isRequired,
  params: PropTypes.object.isRequired,
  quiz: PropTypes.object,
  questions: PropTypes.array,
};

function mapStateToProps(state, props) {
  const quiz = state.entities.quizzes[props.params.id];
  const questions = quiz && quiz.relationships && quiz.relationships.questions.data || [];
  return {
    quiz,
    questions: questions.map(question => state.entities.questions[question.id]),
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators({
      loadQuizWithQuestions,
    }, dispatch),
  };
}

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Quiz);
