import { normalize } from 'normalizr';
import { camelizeKeys, decamelizeKeys } from 'humps';
import fetch from 'isomorphic-fetch';

// Fetches an API response and normalizes the result JSON according to schema.
// This makes every API response have the same shape, regardless of how nested it was.
export default function callApi(endpoint, schema, method = 'get', body) {
  return fetch(`${__API_URL__}/${endpoint}`, {
    method: method.toUpperCase(),
    body: JSON.stringify(decamelizeKeys(body)),
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

      if (schema) {
        return normalize(camelizedJson, schema);
      }

      return camelizedJson;
    })
    .then(
      response => ({ response }),
      errors => ({ errors })
    );
}
