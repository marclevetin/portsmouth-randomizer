import React, {Component} from 'react';

const PickRandomStudent = props => {
  if (!props.randomStudent) {
    return(
      <div>
        <h2>Pick a Random Student</h2>
        <button onClick={props.handleClick}>Get me a student!</button>
      </div>
    )
  } else {
    return(
      <div>
        <h2>Pick a Random Student</h2>
        <h3>{props.randomStudent} will answer the question!</h3>
        <button onClick={props.handleClick}>Get me another student!</button>
      </div>
    )
  }
}

export default PickRandomStudent;
