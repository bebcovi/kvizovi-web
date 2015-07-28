import React from 'react/addons';
import {Link} from 'react-router';
import fetch from '../helpers/fetch-json';
import Loader from '../components/loader';

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
    let content;

    if (this.state.loaded) {
      content = (
        <div className="collection">
          {this.state.quizzes.map((quiz, i) => (
            <Link
              key={i}
              to={`/quizzes/${quiz.id}`}
              className="collection-item">
              {quiz.attributes.name}
            </Link>
          ))}
        </div>
      );
    } else {
      content = <Loader />;
    }

    return (
      <main className="main">
        <div className="container">
          <h1>Kvizovi</h1>
          {content}
        </div>
      </main>
    );
  }
});
