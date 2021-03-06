import React, {Component} from 'react';

// component dependencies
import Button from '../components/Button';
import Bar from '../components/Bar';
import Message from '../components/Message';

class FistToFiveContainer extends Component {
  constructor(props) {
    super(props)

    this.state = {
      activeNumber: '',
      fistToFiveResults: [],
      buttonClicked: false
    }

    this.buttonClick = this.buttonClick.bind(this);
    this.changeAnswer = this.changeAnswer.bind(this);
    this.getScores = this.getScores.bind(this);
    this.resetScores = this.resetScores.bind(this);
  }

  buttonClick(event) {
    const classProgram = location.pathname.slice(1);
    const url = 'api/v1/fisttofive';
    const clickedNumber = event.target.getAttribute("value");
    const payload = JSON.stringify({
      action: 'add',
      number: clickedNumber,
      classProgram: classProgram,
    });

    this.setState({buttonClicked: true});

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
          activeNumber: clickedNumber,
          fistToFiveResults: body.results
        });
      })
      .catch(error => console.error(`Error in fetch: ${error.message}`));
  }

  changeAnswer() {
    const classProgram = location.pathname.slice(1);
    const url = 'api/v1/fisttofive';
    const activeNumber = this.state.activeNumber;
    const payload = JSON.stringify({
      number: activeNumber,
      action: 'change',
      classProgram: classProgram
    });

    fetch(url, {method: "POST", body: payload })
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
          fistToFiveResults: body.results,
          buttonClicked: false
        });
      })
      .catch(error => console.error(`Error in fetch: ${error.message}`));
  }

  componentDidMount() {
    this.reloadScores = setInterval(() => this.getScores(), 500);
  }

  componentWillUnMount() {
    clearInterval(this.reloadScores);
  }

  getScores() {
    const classProgram = location.pathname;
    const url = 'api/v1/fisttofive' + classProgram;

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
          fistToFiveResults: body.results,
          classProgram: classProgram
        });

        if (body.results[5] == true) {
          this.setState({
            activeNumber: '',
            fistToFiveResults: [],
            buttonClicked: false
          })
        }
      })
      .catch(error => console.error(`Error in fetch: ${error.message}`));
  }

  resetScores() {
    const classProgram = location.pathname.slice(1);
    const url = 'api/v1/fisttofive';
    const value = 'reset';
    const now = Date.now()
    const payload = JSON.stringify({
      number: '',
      action: 'reset',
      classProgram: classProgram
    });

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
          activeNumber: '',
          fistToFiveResults: body.results,
          buttonClicked: false
        });
      })
      .catch(error => console.error(`Error in fetch: ${error.message}`));
  }

  render() {
    // allButtons renders only if a button hasn't been clicked.
    // this is designed to prevent a student from clicking more than one,
    // thus causing more than 100% of the class to respond.
    const allButtons = (this.state.buttonClicked) ?
      <Message
        message="Thanks!"
        linkText='Change answer'
        handleClick={this.changeAnswer}
      /> :
      [1,2,3,4,5].map((value, index) => {
        return(
          <Button
            key={'button' + index}
            value={value}
            handleClick={this.buttonClick}
            className='circle'
          />
        )
      })


    const classSize = (this.props.everyone.length) ? this.props.everyone.length : 1;
    const allBars = this.state.fistToFiveResults.filter(number => typeof number === 'number').map((value, index) => {
      let barPercentage = Math.floor(value / classSize * 100);

      return(
        <Bar
          key={'bar' + index}
          className='bar'
          id={value + 1}
          text={index + 1}
          count={value}
          length={barPercentage}
        />
      )
    });


    return(
      <div>
        <h2>Fist to Five</h2>
        <h3>How are you feeling?</h3>
          <p onClick={this.resetScores}>Reset scores</p>
          <hr/>
          <div className="flex-container">
            {allButtons}
          </div>
        <h3>Current Results</h3>
          {allBars}
      </div>
    )
  }
}

export default FistToFiveContainer;
