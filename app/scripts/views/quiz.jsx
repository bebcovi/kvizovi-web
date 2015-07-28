import React from 'react/addons';
import fetch from '../helpers/fetch-json';
import Loader from '../components/loader';

export default React.createClass({
  propTypes: {
    params: React.PropTypes.object.isRequired
  },

  getInitialState() {
    return {
      questions: [],
      loaded: false
    };
  },

  componentDidMount() {
    fetch(`/quizzes/${this.props.params.id}?include=questions`)
      .then(res => {
        this.setState({
          name: res.data.attributes.name,
          questions: res.included,
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

  render () {
    return (
      <main className="main">
        <div className="container">
          <Loader loaded={this.state.loaded}>
            <div className="quiz">
              <h1 className="quiz-name">{this.state.name}</h1>
              <ol className="quiz-questions">
                {this.state.questions.map((question, i) => (
                  <li key={i} className="quiz-question">{question.attributes.title}</li>
                ))}
              </ol>
            </div>
          </Loader>
        </div>
      </main>
    );
  }
});
