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
          questions: res.included || [],
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
    let content, questions;

    if (this.state.loaded) {
      if (this.state.questions.length) {
        questions = (
          <ul className="collection">
            {this.state.questions.map((question, i) => (
              <li key={i} className="collection-item">
                {question.attributes.title}
              </li>
            ))}
          </ul>
        );
      } else {
        questions = <p>Ovaj kviz nema pitanja.</p>;
      }

      content = (
        <div>
          <h1>{this.state.name}</h1>
          {questions}
        </div>
      );
    } else {
      content = <Loader />;
    }

    return (
      <main className="main">
        <div className="container">
          {content}
        </div>
      </main>
    );
  }
});
