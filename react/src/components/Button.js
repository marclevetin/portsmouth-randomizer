import React from 'react';

const Button = props => {
  return(
    <div>
      <p onClick={props.handleClick} value={props.value}>{props.value}</p>
    </div>
  )
}

export default Button;
