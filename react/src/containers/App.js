import React, {Component} from 'react';

// containers dependencies
import StudentGroupContainer from './StudentGroupContainer';
import FistToFiveContainer from './FistToFiveContainer';
import MarkStudentsAbsentContainer from './MarkStudentsAbsentContainer';

// component dependencies
import SelectClassProgram from '../components/SelectClassProgram';
import PickRandomStudent from '../components/PickRandomStudent';
import Student from '../components/Student';

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      students: [],
      randomStudent: '',
      pickedStudents: [],
      absentStudents: [],
      groupCount: 0,
      displayGroupLead: false,
      groupSizeError: false
    }

    this.setGroupCount = this.setGroupCount.bind(this);
    this.randomStudent = this.randomStudent.bind(this);
    this.handleAbsent = this.handleAbsent.bind(this);
    this.validateGroups = this.validateGroups.bind(this);
    this.toggleDisplayGroup = this.toggleDisplayGroup.bind(this);
  }

  componentDidMount() {
    this.fetchData(window.location.pathname);
  }

  handleAbsent(event) {
    const currentStudent = event.target.value;
    const checkedValue = event.target.checked;
    const payload = JSON.stringify({
      currentStudent: currentStudent,
      checked: checkedValue
    });
    const url = 'api/v1/absent';

    fetch(url, {method: "POST", body: payload})
      .then(response => {
        if (response.ok) {
          return response;
        } else {
          let errorMessage = `${response.status} (${response.statusText})`,
            error = new Error(errorMessage);
          throw (error);
        }
      })
      .then(response => response.json())
      .then(body => {
        this.setState({
          absentStudents: body.absent
        })
      })
      .catch(error => console.error(`Error in fetch: ${error.message}`));

  }

  fetchData(classProgram) {
    let data = classProgram;
    let url = '/api/v1/students' + classProgram;

    fetch(url)
      .then(response => {
        if (response.ok) {
          return response;
        } else {
          let errorMessage = `${response.status} (${response.statusText})`,
            error = new Error(errorMessage);
          throw (error);
        }
      })
      .then(response => response.json())
      .then(body => {
        this.setState({
          students: body.students,
          pickedStudents: []
        })
      })
      .catch(error => console.error(`Error in fetch: ${error.message}`));
  }

  toggleDisplayGroup() {
    const newValue = !this.state.displayGroupLead;
    this.setState({
      displayGroupLead: newValue
    })
  }

  randomStudent() {
    if (this.state.students.length !== 0) {
      // removes absent students from the list.
      // let activeStudents = this.state.students.slice(); // copy array
      // let presentStudents = activeStudents.filter(student => !this.state.absentStudents.includes(student))
      //

      // finds a random student to answer the question
      const randomIndex = Math.floor(Math.random() * this.state.students.length);
      const luckyDuck = this.state.students[randomIndex];

      // moves that student to "picked" list, so they won't be asked again until everyone in the class has answered
      let updatedStudents = this.state.students.slice(); //copy array
      updatedStudents.splice(randomIndex, 1); //remove element

      this.setState({
        randomStudent: luckyDuck,
        pickedStudents: [...this.state.pickedStudents, luckyDuck],
        students: updatedStudents
        }
      )
    } else if (this.state.students.length === 0) {
      // resets the set of students when everyone has been picked
      this.setState({
        students: this.state.pickedStudents,
        pickedStudents: ''
      })
    }
  }

  render() {
    const allStudents = (this.state.pickedStudents.length === 0) ? this.state.students : [...this.state.students,this.state.pickedStudents]

    return(
      <div>
        <MarkStudentsAbsentContainer
          everyone={allStudents}
          absent={this.state.absentStudents}
          handleAbsent={this.handleAbsent}
        />
        <PickRandomStudent
          handleClick={this.randomStudent}
          randomStudent={this.state.randomStudent}
        />
        <StudentGroupContainer
          everyone={allStudents}
          absent={this.state.absentStudents}
          groupCount={this.state.groupCount}
          displayGroupLead={this.state.displayGroupLead}
          handleChange={this.setGroupCount}
          handleLeadChange={this.toggleDisplayGroup}
          error={this.state.groupSizeError}
        />
        <FistToFiveContainer
          everyone={allStudents}
        />
      </div>
    )
  }

  resetAbsent() {
    const url = 'api/v1/absent'
    const payload = JSON.stringify({
      reset: true
    })
    fetch(url, {method: "POST", body: payload})
      .then(response => {
        if (response.ok) {
          return response;
        } else {
          let errorMessage = `${response.status} (${response.statusText})`,
            error = new Error(errorMessage);
          throw (error);
        }
      })
      .then(response => response.json())
      .then(body => {
        this.setState({
          absentStudents: body.absent
        })
      })
      .catch(error => console.error(`Error in fetch: ${error.message}`));

  }

  setGroupCount(event) {
    this.validateGroups(event.target.value);
    this.setState({
      groupCount: event.target.value
    });
  }

  validateGroups(size) {
    if (size > this.state.students.length) {
      this.setState({
        groupSizeError: true
      })
    } else {
      this.setState({
        groupSizeError: false
      })
    }
  }
}

export default App;
