import React from 'react';

const Group = props => {
  return(
    <div className="group">
      <h3>Group {props.index}</h3>
      <p>
        {props.lead} (lead), {props.participants.join(', ')}
      </p>
    </div>
  )
}

export default Group;
