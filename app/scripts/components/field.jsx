import React from 'react/addons';
import Formsy from 'formsy-react';
import classNames from 'classnames';

export default React.createClass({
  propTypes: {
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
      <div className={classNames('form-group', {
        'is-required': this.showRequired(),
        'has-error': this.showError()
      })}>
        <label
          className="form-label"
          htmlFor={this.props.name}>
          {this.props.label}
        </label>
        <div className="form-control-outer">
          <input
            id={this.props.name}
            className="form-control"
            type={this.props.type}
            onChange={this.changeValue}
            value={this.getValue()} />
            <div className="form-feedback">
              {this.getErrorMessage()}
            </div>
        </div>
      </div>
    );
  }
});
