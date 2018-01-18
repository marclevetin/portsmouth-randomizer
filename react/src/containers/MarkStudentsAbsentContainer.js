import React from 'react';

// component dependencies
import Checkbox from '../components/Checkbox'

const MarkStudentsAbsentContainer = props => {
  props.everyone.sort()

  const allCheckboxes = props.everyone.map(student => {
    const isAbsent = props.absent.includes(student)
    return(
      <Checkbox
        key={Math.random()}
        form="absent"
        name={student}
        onChange={props.handleAbsent}
        checked={isAbsent}
      />
    )
  })

  return(
    <div>
      <form>
        <label>
          Who's absent?
          {allCheckboxes}
        </label>
      </form>
    </div>
  )
}

export default MarkStudentsAbsentContainer;
