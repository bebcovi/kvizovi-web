import React from 'react/addons';
import {Form} from 'formsy-react';
import Field from '../../components/field';

export default React.createClass({
  render() {
    return (
      <section>
        <h2>Forms</h2>
        <Form>
          <Field
            name="email"
            type="email"
            label="E-mail"
            validations="isEmail"
            validationError="E-mail adresa nije validna"
            required />
        </Form>
      </section>
    );
  }
});
