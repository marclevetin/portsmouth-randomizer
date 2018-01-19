import React from 'react';

const Message = props => {
  return(
    <div>
      <h3>{props.message}</h3>
      <p onClick={props.handleClick}>{props.linkText}</p>
    </div>
  )
};

export default Message;
