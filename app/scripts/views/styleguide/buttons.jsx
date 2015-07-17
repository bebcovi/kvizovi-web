import React from 'react/addons';
import colors from '../../colors';

export default React.createClass({
  render() {
    return (
      <section>
        <h2>Buttons</h2>
        <div className="btn-group">
          {colors.map((color, i) => (
            <button
              key={i}
              className={`btn btn-${color.toLowerCase()}`}
              type="button">
              {color}
            </button>
          ))}
        </div>
        <div className="btn-group">
          {colors.map((color, i) => (
            <button
              key={i}
              className={`btn btn-${color.toLowerCase()}`}
              type="button"
              disabled>
              {color}
            </button>
          ))}
        </div>
      </section>
    );
  }
});
