import React, {Component} from 'react';

// component dependencies
import Checkbox from '../components/Checkbox'

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
    this.props.everyone.sort();


    const allCheckboxes = this.props.everyone.map(student => {
      const isAbsent = this.props.absent.includes(student)
      return(
        <Checkbox
          key={Math.random()}
          form="absent"
          name={student}
          onChange={this.props.handleAbsent}
          checked={isAbsent}
        />
      )
    });

    return(
      <div>
        <h2>Absent students</h2>
        <p onClick={this.toggleView}>{(this.state.show) ? 'Hide students' : 'Show students' }</p>
        <form>
          <label>
            {(this.state.show) ? 'Who\'s absent?' : '' }
            {(this.state.show) ? allCheckboxes : '' }
          </label>
        </form>
      </div>
    )
  }
}

export default MarkStudentsAbsentContainer;
