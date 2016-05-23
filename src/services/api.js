import { Schema, arrayOf } from 'normalizr';
import callApi from '../helpers/call-api';

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
