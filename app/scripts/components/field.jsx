import React from 'react/addons';
import Formsy from 'formsy-react';
import classNames from 'classnames';

export default React.createClass({
  propTypes: {
    className: React.PropTypes.string,
    label: React.PropTypes.string.isRequired,
    name: React.PropTypes.string.isRequired,
    type: React.PropTypes.string
  },

  mixins: [Formsy.Mixin],

  changeValue(event) {
    this.setValue(event.currentTarget.value);
  },

  render() {
    return (
      <div className={classNames('input-field', this.props.className)}>
        <input
          id={this.props.name}
          className={classNames('form-control', {
            'invalid': this.showError()
          })}
          type={this.props.type}
          onChange={this.changeValue}
          value={this.getValue()} />
        <label
          htmlFor={this.props.name}
          data-error={this.getErrorMessage()}>
          {this.props.label}
        </label>
      </div>
    );
  }
});
