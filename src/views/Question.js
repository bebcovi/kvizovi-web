import React, { PropTypes } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { loadQuestion } from '../actions';

export class Question extends React.Component {
  componentWillMount() {
    this.props.actions.loadQuestion(this.props.params);
  }

  render() {
    const { question } = this.props;
    return (
      <div>
        {question && (
          <div>
            {question.attributes.title}
          </div>
        )}
      </div>
    );
  }
}

Question.propTypes = {
  actions: PropTypes.object.isRequired,
  params: PropTypes.object.isRequired,
  question: PropTypes.object,
};

function mapStateToProps(state, props) {
  return {
    question: state.entities.questions[props.params.questionId],
  };
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators({
      loadQuestion,
    }, dispatch),
  };
}

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Question);
