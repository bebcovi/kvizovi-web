import { Schema, arrayOf } from 'normalizr';
import callApi from '../utils/call-api';

// We use this Normalizr schemas to transform API responses from a nested form
// to a flat form where repos and users are placed in `entities`, and nested
// JSON objects are replaced with their IDs. This is very convenient for
// consumption by reducers, because we can easily build a normalized tree
// and keep it updated as we fetch more data.

// Read more about Normalizr: https://github.com/gaearon/normalizr

// Schemas for Github API responses.
const QUIZ = new Schema('quizzes');
const QUIZ_ARRAY = arrayOf(QUIZ);
const QUESTION = new Schema('questions');
const QUESTION_ARRAY = arrayOf(QUESTION);

// api services
/* eslint-disable max-len */
export const fetchQuizzes = () => callApi('quizzes', { data: QUIZ_ARRAY });
export const fetchQuiz = id => callApi(`quizzes/${id}`, { data: QUIZ });
export const fetchQuizWithQuestions = id => callApi(`quizzes/${id}?include=questions`, { data: QUIZ, included: QUESTION_ARRAY });
export const updateQuiz = data => callApi(`quizzes/${data.id}`, null, 'patch', { data });
export const fetchQuestions = quizId => callApi(`quizzes/${quizId}/questions`, { data: QUESTION_ARRAY });
export const fetchQuestion = ({ quizId, questionId }) => callApi(`quizzes/${quizId}/questions/${questionId}`, { data: QUESTION });
/* eslint-enable */
