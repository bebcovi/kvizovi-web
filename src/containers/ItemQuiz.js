import React, { PropTypes } from 'react';
import shallowCompare from 'react-addons-shallow-compare';
import { Link } from 'react-router';
import { Row, Col } from 'react-flexbox-grid';
import { IconEdit } from '../components/Icon';

export class ItemQuiz extends React.Component {
  constructor(props) {
    super(props);
    this._handleEdit = this._handleEdit.bind(this);
  }

  shouldComponentUpdate(nextProps) {
    return shallowCompare(this, nextProps);
  }

  _handleEdit() {
    this.props.onEdit(this.props.id);
  }

  render() {
    return (
      <Row>
        <Col xs>
          <Link to={`/quizzes/${this.props.id}`}>
            {this.props.name}
          </Link>
        </Col>
        {this.props.onEdit && (
          <button
            type="button"
            onClick={this._handleEdit}
          >
            <IconEdit />
          </button>
        )}
      </Row>
    );
  }
}

ItemQuiz.propTypes = {
  id: PropTypes.string.isRequired,
  name: PropTypes.string.isRequired,
  onEdit: PropTypes.func,
};

export default ItemQuiz;
