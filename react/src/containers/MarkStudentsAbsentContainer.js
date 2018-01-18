import React, {Component} from 'react';

// component dependencies
import Checkbox from '../components/Checkbox'

class MarkStudentsAbsentContainer extends Component {
  constructor(props) {
    super(props)

    this.state = {

    }
  }


  render() {
    this.props.everyone.sort()

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

}

export default MarkStudentsAbsentContainer;
