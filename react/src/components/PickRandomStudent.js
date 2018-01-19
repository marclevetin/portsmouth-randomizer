import React, {Component} from 'react';

// component dependencies
import Button from './Button';

const PickRandomStudent = props => {
  if (!props.randomStudent) {
    return(
      <div>
        <h2>Pick a Random Student</h2>
        <Button
          handleClick={props.handleClick}
          value='Get a student'
          className='square'
        />
      </div>
    );
  } else {
    return(
      <div>
        <h2>Pick a Random Student</h2>
        <h3>{props.randomStudent} will answer the question!</h3>
        <Button
          handleClick={props.handleClick}
          value='Get another student'
          className='square'
        />
      </div>
    )
  }
};

export default PickRandomStudent;
