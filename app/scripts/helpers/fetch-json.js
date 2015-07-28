import 'es6-promise';
import 'whatwg-fetch';

function status(response) {
  if (response.status >= 200 && response.status < 300) {
    return Promise.resolve(response);
  } else {
    return Promise.reject(new Error(response.statusText));
  }
}

function json(response) {
  return response.json();
}

export default function (url, options) {
  return fetch(`http://localhost:3000${url}`, options)
    .then(status)
    .then(json);
}
