import React from 'react/addons';
import {Link} from 'react-router';
import $ from 'jquery';

export default React.createClass({
  componentDidMount() {
    $('.button-collapse').sideNav();
  },

  render() {
    return (
      <div className="navbar-fixed">
        <nav className="z-depth-0">
          <div className="nav-wrapper">
            <div className="container">
              <Link to="/" className="brand-logo">
                <i className="material-icons left hide-on-small-only">book</i>Kvizovi
              </Link>
              <a href="#" data-activates="mobile-demo" className="button-collapse">
                <i className="material-icons">menu</i>
              </a>
              <ul className="right hide-on-med-and-down">
                <li>
                  <Link to="/profile" activeClass="active">
                    <i className="material-icons left">account_circle</i>Profil
                  </Link>
                </li>
              </ul>
              <ul className="side-nav" id="mobile-demo">
                <li>
                  <Link to="/profile" activeClass="active">
                    <i className="material-icons left hide-on-small-only">account_circle</i>Profil
                  </Link>
                </li>
              </ul>
            </div>
          </div>
        </nav>
      </div>
    );
  }
});
