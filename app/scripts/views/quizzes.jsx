import React from 'react/addons';
import {Link} from 'react-router';
import fetch from 'fetch';
import Loader from 'loader';

export default React.createClass({
  getInitialState() {
    return {
      loaded: false,
      quizzes: []
    };
  },

  componentDidMount() {
    fetch('/quizzes')
      .then(res => {
        this.setState({
          quizzes: res.data,
          loaded: true
        });
      })
      .catch(err => {
        console.error(err);
        this.setState({
          loaded: true
        });
      });
  },

  render() {
    return (
      <div className="container">
        <h1>Kvizovi</h1>

        <Loader loaded={this.state.loaded}>
          <ol className="quiz-list">
            {this.state.quizzes.map((quiz, i) => (
              <li key={i} className="quiz-item">
                <Link to={`/quizzes/${quiz.id}`}>
                  {quiz.attributes.name}
                </Link>
              </li>
            ))}
          </ol>
        </Loader>
      </div>
    );
  }
});
