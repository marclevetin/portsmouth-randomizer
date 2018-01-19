import React from 'react';

const Form = props => {
  return(
    <div>
      <form>
        <label>
          {props.label}
          {props.checkboxes}
        </label>
      </form>
    </div>
  )
};

export default Form;
