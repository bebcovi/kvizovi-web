import React, { PropTypes } from 'react';
import { Row, Col } from 'react-flexbox-grid';
import { IconEdit } from '../components/Icon';

export class ItemQuiz extends React.Component {
  constructor(props) {
    super(props);
    this._handleEdit = this._handleEdit.bind(this);
  }

  _handleEdit() {
    this.props.onEdit(this.props.id);
  }

  render() {
    return (
      <Row>
        <Col xs>{this.props.attributes.name}</Col>
        <button
          type="button"
          onClick={this._handleEdit}
        >
          <IconEdit />
        </button>
      </Row>
    );
  }
}

ItemQuiz.propTypes = {
  id: PropTypes.string.isRequired,
  attributes: PropTypes.object.isRequired,
  onEdit: PropTypes.func.isRequired,
};

export default ItemQuiz;
