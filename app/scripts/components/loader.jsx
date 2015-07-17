import React from 'react/addons';
import Loader from 'react-loader';

export default React.createClass({
  propTypes: {
    children: React.PropTypes.node.isRequired,
    loaded: React.PropTypes.bool.isRequired
  },

  render() {
    return (
      <Loader
        loaded={this.props.loaded}
        color="gray">
        {this.props.children}
      </Loader>
    );
  }
});
