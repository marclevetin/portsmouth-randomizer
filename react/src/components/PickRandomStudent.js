import React, {Component} from 'react';

const PickRandomStudent = props => {
  return(
    <div>
      <h2>{props.randomStudent} will answer the question!</h2>
      <button onClick={props.handleClick}>Get me another student!</button>
    </div>
  )
}

export default PickRandomStudent;
