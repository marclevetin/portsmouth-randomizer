import React from 'react';

const Button = props => {
  return(
    <div>
      <p className={props.className} onClick={props.handleClick} value={props.value}>{props.value}</p>
    </div>
  )
};

export default Button;
