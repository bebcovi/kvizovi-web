import React, { PropTypes } from 'react';
import shallowCompare from 'react-addons-shallow-compare';

class Link extends React.Component {
  constructor(props) {
    super(props);
    this._handleClick = this._handleClick.bind(this);
  }

  shouldComponentUpdate(nextProps) {
    return shallowCompare(this, nextProps);
  }

  _handleClick(event) {
    event.preventDefault();
    this.props.onClick();
  }

  render() {
    return (
      <a
        href="#"
        {...this.props}
        onClick={this._handleClick}
      >
        {this.props.children}
      </a>
    );
  }
}

Link.propTypes = {
  children: PropTypes.node,
  onClick: PropTypes.func,
};

Link.defaultProps = {
  onClick: () => {},
};

export default Link;
