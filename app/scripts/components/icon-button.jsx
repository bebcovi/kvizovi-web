import React from 'react/addons';
import {FontIcon} from 'material-ui';

export default React.createClass({
  propTypes: {
    children: React.PropTypes.element.isRequired,
    symbol: React.PropTypes.string.isRequired
  },

  render() {
    return React.cloneElement(
      this.props.children,
      {labelStyle: '0 16px 0 8px'},
      (
        <FontIcon
          className="material-icons"
          style={{float: 'left', lineHeight: '36px', paddingLeft: '12px'}}>
          {this.props.symbol}
        </FontIcon>
      )
    );
  }
});
