import React, { PropTypes } from 'react';
import shallowCompare from 'react-addons-shallow-compare';
import { Link } from 'react-router';

class ItemQuestion extends React.Component {
  constructor(props) {
    super(props);
  }

  shouldComponentUpdate(nextProps) {
    return shallowCompare(this, nextProps);
  }

  render() {
    return (
      <div>
        <Link to={`/quizzes/${this.props.quizId}/questions/${this.props.id}`}>
          {this.props.title}
        </Link>
      </div>
    );
  }
}

ItemQuestion.propTypes = {
  id: PropTypes.string.isRequired,
  quizId: PropTypes.string.isRequired,
  title: PropTypes.string.isRequired,
};

export default ItemQuestion;
