import React, { PropTypes } from 'react';
import { Row, Col } from 'react-flexbox-grid';
import { Field, reduxForm } from 'redux-form';

const ItemQuizForm = (props) => (
  <form onSubmit={props.handleSubmit}>
    <Row>
      <Col xs>
        <Field
          name="attributes.name"
          component={name => (
            <input
              autoFocus
              type="text"
              {...name}
            />
          )}
        />
      </Col>
      <button type="submit">
        {'Save'}
      </button>
    </Row>
  </form>
);

ItemQuizForm.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
};

export default reduxForm({
  form: 'quiz',
})(ItemQuizForm);
