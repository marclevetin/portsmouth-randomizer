import React from 'react';

const Group = props => {
  const displayGroupLead = (props.displayGroupLead) ? "(lead)" : ""
  return(
    <div className="group">
      <h3>Group {props.index}</h3>
      <p>
        {props.lead} {displayGroupLead}, {props.participants.join(', ')}
      </p>
    </div>
  )
};

export default Group;
