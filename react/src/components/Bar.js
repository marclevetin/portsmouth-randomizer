import React from 'react';

const Bar = props => {
  return(
    <div>
      <p className={props.className} style={{width: props.length + "%"}} id={props.id}># of {props.text}s: {props.count} ({props.length}%)</p>
    </div>
  )
};

export default Bar;
