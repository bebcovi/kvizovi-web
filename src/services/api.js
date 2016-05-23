import { Schema, arrayOf, normalize } from 'normalizr';
import { camelizeKeys } from 'humps';
import 'isomorphic-fetch';

// Fetches an API response and normalizes the result JSON according to schema.
// This makes every API response have the same shape, regardless of how nested it was.
function callApi(endpoint, schema, method = 'get') {
  return fetch(`${__API_URL__}/${endpoint}`, {
    method,
    headers: {
      'content-type': 'application/json',
    },
  })
    .then(response => response.json().then(json => ({ json, response })))
    .then(({ json, response }) => {
      const camelizedJson = camelizeKeys(json);

      if (!response.ok) {
        return Promise.reject(camelizedJson.errors);
      }

      return normalize(camelizedJson, schema);
    })
    .then(
      response => ({ response }),
      errors => ({ errors })
    );
}

// We use this Normalizr schemas to transform API responses from a nested form
// to a flat form where repos and users are placed in `entities`, and nested
// JSON objects are replaced with their IDs. This is very convenient for
// consumption by reducers, because we can easily build a normalized tree
// and keep it updated as we fetch more data.

// Read more about Normalizr: https://github.com/gaearon/normalizr

// Schemas for Github API responses.
const QUIZ = new Schema('quizzes');
const QUIZ_ARRAY = arrayOf(QUIZ);

// api services
export const fetchQuizzes = () => callApi('quizzes', { data: QUIZ_ARRAY });
