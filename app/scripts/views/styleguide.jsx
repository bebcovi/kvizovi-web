import React from 'react/addons';
import {RouteHandler, Link} from 'react-router';

export default React.createClass({
  render() {
    const pages = [
      'Buttons',
      'Forms'
    ];

    return (
      <div className="container styleguide">
        <h1>Styleguide</h1>
        <div className="styleguide-inner">
          <nav>
            <ol className="navigation-list">
              {pages.map((page, i) => (
                <li key={i} className="navigation-item">
                  <Link
                    to={`/styleguide/${page.toLowerCase()}`}
                    activeClassName="active">
                    {page}
                  </Link>
                </li>
              ))}
            </ol>
          </nav>
          <main>
            <RouteHandler />
          </main>
        </div>
      </div>
    );
  }
});
