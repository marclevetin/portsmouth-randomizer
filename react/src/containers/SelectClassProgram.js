import React, {Component} from 'react';

// component dependencies
import Student from '../components/Student'

const SelectClassProgram = props => {
  return(
    <div>
      <form>
        <label>
          Class:
          <select value={props.current} onChange={props.handleChange}>
            <option value='select'>Select a class</option>
            <option value='unh'>September 2017 - March 2018</option>
            <option value='unh1'>November 2018 - May 2018</option>
          </select>
        </label>
      </form>
    </div>
  )
}

export default SelectClassProgram;
