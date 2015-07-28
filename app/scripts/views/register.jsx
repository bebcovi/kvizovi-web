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
      <main className="main">
        <div className="container">
          <Form
            onValidSubmit={this.submit}
            onValid={this.enableSubmit}
            onInvalid={this.disableSubmit}>

            <h1>Registracija</h1>

            <div className="row">
              <Field
                className="col s6"
                name="name"
                label="Nadimak"
                type="text"
                required />
              <Field
                className="col s6"
                name="email"
                type="email"
                label="E-mail"
                validations="isEmail"
                validationError="E-mail adresa nije validna."
                required />
            </div>

            <button
              className="btn-large"
              type="submit"
              disabled={!this.state.canSubmit}>
              Submit
            </button>

          </Form>
        </div>
      </main>
    );
  }
});
