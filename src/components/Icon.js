import React, { PropTypes } from 'react';
import style from '../styles/Icon.scss';
import classNames from 'classnames';

const Icon = (props) => (
  <div
    className={classNames([
      style.container,
      style[props.color],
      props.className,
    ])}
    onClick={props.onClick}
  >
    <svg
      viewBox={`0 0 ${props.width} ${props.height}`}
      width={props.width * props.size}
      height={props.height * props.size}
      fill="currentColor"
    >
      {props.children}
    </svg>
  </div>
);

Icon.propTypes = {
  children: PropTypes.node,
  className: PropTypes.string,
  color: PropTypes.string,
  height: PropTypes.number.isRequired,
  width: PropTypes.number.isRequired,
  size: PropTypes.number,
  onClick: PropTypes.func,
};

Icon.defaultProps = {
  size: 1,
};

export default Icon;

/* eslint-disable max-len */

export const IconEdit = () => (
  <Icon width={24} height={24}>
    <title>{'pencil'}</title>
    <path d="M12.91 0.604l-8.799 15.705 0.045 0.023 0.445 7.064 6.447-3.202 0.041 0.023 8.799-15.704-6.978-3.909zM6.055 20.9l-0.061-3.539 3.199 1.793-3.138 1.746zM10.322 17.496l-3.488-1.955 5.377-9.597 3.49 1.954-5.379 9.598zM12.699 5.071l0.979-1.745 3.488 1.955-0.977 1.744-3.49-1.954z" />
  </Icon>
);
