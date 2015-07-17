import React from 'react/addons';
import {Form} from 'formsy-react';
import Field from '../components/field';

export default React.createClass({
  getInitialState() {
    return {
      canSubmit: false
    };
  },

  enableSubmit() {
    this.setState({
      canSubmit: true
    });
  },

  disableSubmit() {
    this.setState({
      canSubmit: false
    });
  },

  submit() {

  },

  render() {
    return (
      <div className="container">
        <Form
          onValidSubmit={this.submit}
          onValid={this.enableSubmit}
          onInvalid={this.disableSubmit}>
          <h1>Registracija</h1>
          <Field
            name="name"
            label="Nadimak"
            required />
          <Field
            name="email"
            type="email"
            label="E-mail"
            validations="isEmail"
            validationError="E-mail adresa nije validna"
            required />
          <button
            className="btn btn-primary"
            type="submit"
            disabled={!this.state.canSubmit}>
            Submit
          </button>
        </Form>
      </div>
    );
  }
});
