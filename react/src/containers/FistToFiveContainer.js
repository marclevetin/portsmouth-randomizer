import React, {Component} from 'react';

// component dependencies
import Button from '../components/Button'

class FistToFiveContainer extends Component {
  constructor(props) {
    super(props)

    this.state = {
      activeNumber: '',
      fistToFiveResults: []
    }

    this.getScores = this.getScores.bind(this)
    this.buttonClick = this.buttonClick.bind(this)
    this.resetScores = this.resetScores.bind(this)
  }

  getScores() {
    const url = 'api/v1/fisttofive'

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
          activeNumber: '',
          fistToFiveResults: body.results
        })
      })
      .catch(error => console.error(`Error in fetch: ${error.message}`));
  }

  resetScores() {
    const url = 'api/v1/fisttofive'
    const value = 'reset'

    fetch(url, {method: "POST", body: value})
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
          activeNumber: '',
          fistToFiveResults: body.results
        })
      })
      .catch(error => console.error(`Error in fetch: ${error.message}`));
  }

  buttonClick(event) {
    const url = 'api/v1/fisttofive'
    const value = event.target.getAttribute("value")

    fetch(url, {method: "POST", body: value})
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
          activeNumber: value,
          fistToFiveResults: body.results
        })
      })
      .catch(error => console.error(`Error in fetch: ${error.message}`));
  }

  componentDidMount() {
    this.reloadScores = setInterval(() => this.getScores(), 2000)
  }

  componentWillUnMount() {
    clearInterval(this.reloadScores)
  }

  render() {
    const allButtons = [1,2,3,4,5].map(value => {return(
      <Button
        key={Math.random()}
        value={value}
        handleClick={this.buttonClick}
      />
    )})
    return(
      <div>
        <h2>Fist to Five</h2>
        <h3>How are you feeling?</h3>
          <p onClick={this.resetScores}>Reset scores</p>
          <hr/>
          {allButtons}
        <h3>Current Results</h3>
        <p>1s: {this.state.fistToFiveResults[0]}</p>
        <p>2s: {this.state.fistToFiveResults[1]}</p>
        <p>3s: {this.state.fistToFiveResults[2]}</p>
        <p>4s: {this.state.fistToFiveResults[3]}</p>
        <p>5s: {this.state.fistToFiveResults[4]}</p>
      </div>
    )
  }

}

export default FistToFiveContainer;
