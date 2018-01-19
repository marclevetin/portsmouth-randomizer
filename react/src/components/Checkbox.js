import React from 'react';

const Checkbox = props => {
  return(
    <div>
      <input type="checkbox" value={props.name} name={props.form} onChange={props.onChange} checked={props.checked}/> {props.name} <br />
    </div>
  )
};

export default Checkbox;
