import React, {Component} from 'react';

// containers dependencies
import SelectClassProgram from './SelectClassProgram';
import StudentGroupContainer from './StudentGroupContainer';
import FistToFiveContainer from './FistToFiveContainer';
import MarkStudentsAbsentContainer from './MarkStudentsAbsentContainer';

// component dependencies
import PickRandomStudent from '../components/PickRandomStudent';
import Student from '../components/Student';

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      currentClassProgram: 'select',
      students: [],
      randomStudent: '',
      pickedStudents: [],
      absentStudents: [],
      groupCount: 0
    }

    this.setGroupCount = this.setGroupCount.bind(this);
    this.pickClass = this.pickClass.bind(this);
    this.randomStudent = this.randomStudent.bind(this);
  }

  setGroupCount(event) {
    this.setState({
      groupCount: event.target.value
    })
  }

  pickClass(event) {
    this.setState({currentClassProgram: event.target.value});
    this.fetchData(event.target.value)
  }

  fetchData(classProgram) {
    let url = '/api/v1/students'
    let data = classProgram

    fetch(url, {method: "POST", body: data})
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
          pickedStudents: [],
          absentStudents: []
        })
      })
      .catch(error => console.error(`Error in fetch: ${error.message}`));
  }

  randomStudent() {
    if (this.state.students.length !== 0) {
    const randomIndex = Math.floor(Math.random() * this.state.students.length)
    const luckyDuck = this.state.students[randomIndex]

    let updatedStudents = this.state.students.slice(); //copy array
    updatedStudents.splice(randomIndex, 1); //remove element

    this.setState({
      randomStudent: luckyDuck,
      pickedStudents: [...this.state.pickedStudents, luckyDuck],
      students: updatedStudents
      }
      ,
      console.log(this.state)
    )
    } else if (this.state.students.length === 0) {
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
        <SelectClassProgram
          handleChange={this.pickClass}
        />
        <PickRandomStudent
          handleClick={this.randomStudent}
          randomStudent={this.state.randomStudent}
        />
        <StudentGroupContainer
          everyone={allStudents}
          groupCount={this.state.groupCount}
          handleChange={this.setGroupCount}
        />
        <FistToFiveContainer />
        <MarkStudentsAbsentContainer />

      </div>
    )
  }
}

export default App;
