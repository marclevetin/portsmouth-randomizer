import React, {Component} from 'react';

// component dependencies
import Checkbox from '../components/Checkbox';
import Form from '../components/Form';

class MarkStudentsAbsentContainer extends Component {
  constructor(props) {
    super(props)

    this.state = {
      show: false
    }

    this.toggleView = this.toggleView.bind(this);
  }

  toggleView() {
    const currentState = this.state.show;

    this.setState({
      show: !currentState
    });
  }

  render(){
    // ensures that students are presented in the same order every time.
    this.props.everyone.sort();

    // assembles the list of checkboxes for the form
    const allCheckboxes = this.props.everyone.map((student, index) => {
      const isAbsent = this.props.absent.includes(student)
      return(
        <Checkbox
          key={`absent${index}`}
          form="absent"
          name={student}
          onChange={this.props.handleAbsent}
          checked={isAbsent}
        />
      )
    });

    const form = <Form
      checkboxes={allCheckboxes}
      label="Who's absent"
    />;

    return(
      <div>
        <p onClick={this.toggleView}>{(this.state.show) ? 'Hide students' : 'Mark students absent' }</p>
        {(this.state.show) ? form : ''}
      </div>
    )
  }
}

export default MarkStudentsAbsentContainer;
