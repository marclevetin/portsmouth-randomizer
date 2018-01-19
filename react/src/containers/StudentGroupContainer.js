
import React, {Component} from 'react';

// component dependencies
import Group from '../components/Group'

class StudentGroupContainer extends Component {
  constructor(props) {
    super(props)

    this.state = {
    }

    this.createGroups = this.createGroups.bind(this)
  }

  createGroups(array, size) {
    // this opening if is required for initial renders and when the box is empty
    if (size === 0 || size === '') {
      return []
    } else {
      // creates the initial set of groups of X size, plus a possible set of "remainder" students as the final group
      let groups = []
      for (let i = 0; i < array.length; i += size) {
        groups.push(array.slice(i, i + size));
      }

      // distribute "remainder" students from the last group to the others.
      let lastGroup = groups[groups.length - 1]
      if (lastGroup.length < size) {
        let groupIterator = 0
        while (lastGroup.length > 0) {
          let student = lastGroup[0]
          groups[groupIterator].push(student)
          lastGroup.shift()
          // this if block ensures that a remainder students are equally distributed among all groups
          if (groupIterator < groups.length - 1) {
            groupIterator += 1
          } else {
            groupIterator = 0
          }
        }
      }
      // the if block above distributes all "remainders", but it leaves an empty array element that needs to be removed.
      groups.pop()

      return groups;
    }
  }

  render() {
    // randomize students
    const randomizedStudents = this.props.everyone.sort((a, b) => 0.5 - Math.random())

    // build groups
    const allGroups = this.createGroups(randomizedStudents, parseInt(this.props.groupCount))

    const groupComponents = allGroups.map((group, index) => {
      return(
        <Group
          key={index}
          index={index + 1}
          lead={group[0]}
          participants={group.slice(1)}
        />
      )
    })

    return(
      <div>
        <h2>Group creator</h2>
        <p>Enter number of people per group</p>
        <input type="number" value={this.props.groupCount} onChange={this.props.handleChange}></input>
        <hr />
        {groupComponents}
      </div>
    )
  }

}

export default StudentGroupContainer;
