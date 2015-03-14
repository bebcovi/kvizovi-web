# Kvizovi API

## Table of contents

* [**Introduction**](#introduction)
* [**Users**](#users)
  - [Creating users](#creating-users)
  - [Retrieving users](#retrieving-users)
  - [Updating users](#updating-users)
  - [Deleting users](#deleting-users)
* [**Quizzes**](#quizzes)
  - [Creating quizzes](#creating-quizzes)
  - [Retrieving quizzes](#retrieving-quizzes)
  - [Updating quizzes](#updating-quizzes)
  - [Deleting quizzes](#deleting-quizzes)
* [**Questions**](#questions)
  - [Creating questions](#creating-questions)
  - [Retrieving questions](#retrieving-questions)
  - [Updating questions](#updating-questions)

## Introduction

All requests should be sent and all responses are returned as JSON.

```http
GET /account HTTP/1.1
Content-Type: application/json

{"user": {"email": "janko.marohnic@gmail.com", "password": "secret"}}
```

If a request fails, the appropriate response status will be returned, often
following up with an error message.

```http
HTTP/1.1 400 Bad Request
Content-Type: application/json

{"errors": ["Invalid email or password"]}
```

To make authorized requests, include user's token in the "Authorization"
header.

```http
GET /quizzes HTTP/1.1
Authorization: Token token="abc123"
```

## Users

| Attribute  | Type    |
| ---------  | ----    |
| `id`       | integer |
| `nickname` | string  |
| `email`    | string  |
| `token`    | string  |

### Retrieving users

```http
GET /account HTTP/1.1
Content-Type: application/json

{"user": {"email": "janko.marohnic@gmail.com", "password": "secret"}}
```
```http
GET /account HTTP/1.1
Content-Type: application/json

{"user": {"token": "abc123"}}
```

### Creating users

```http
POST /account HTTP/1.1
Content-Type: application/json

{
  "user": {
    "nickname": "Junky",
    "email": "janko.marohnic@gmail.com",
    "password": "secret"
  }
}
```

If the user is successfully registered, a confirmation email will be sent
to their email address. The email will include a link to
`http://kvizovi.org/account/confirm?token=abc123`. When user visits that URL,
the appropriate request has to be made to the API:

```http
PUT /account/confirm HTTP/1.1
Content-Type: application/json

{"token": "abc123"}
```

### Updating users

```http
PUT /account HTTP/1.1
Authorization: Token token="abc123"
Content-Type: application/json

{"user": {"old_password": "secret", "password": "new secret"}}
```

#### Password reset

```http
POST /account/password HTTP/1.1
Content-Type: application/json

{"user": {"email": "janko.marohnic@gmail.com"}}
```

This will send the password reset instructions to the user's email address.
The email will include a link to
`http://kvizovi.org/account/password?token=abc123`. When the user visits the
link and enters the new password, an API request needs to be made with
the password reset token included:

```http
PUT /account/password HTTP/1.1
Content-Type: application/json

{
  "token": "abc123",
  "user": {"password": "new secret"}
}
```

### Deleting users

```http
DELETE /account HTTP/1.1
Authorization: Token token="abc123"
```

## Quizzes

| Attribute         | Type    |
| ---------         | ----    |
| `id`              | integer |
| `name`            | string  |
| `category`        | string  |
| `questions_count` | integer |
| `created_at`      | time    |
| `updated_at`      | time    |

## Retrieving quizzes

To return quizzes from a user, include the authorization token:

```http
GET /quizzes HTTP/1.1
Authorization: Token token="abc123"
```

Without an authorization token you're searching all quizzes:

```http
GET /quizzes?q=matrix HTTP/1.1
```
```http
GET /quizzes?category=movies HTTP/1.1
```
```http
GET /quizzes?page=1&per_page=10 HTTP/1.1
```

### Creating quizzes

```http
POST /quizzes HTTP/1.1
Authorization: Token token="abc123"
Content-Type: application/json

{
  "quiz": {
    "name": "Game of Thrones",
    "category": "movies"
  }
}
```

### Updating quizzes

```http
PUT /quizzes/1 HTTP/1.1
Authorization: Token token="abc123"
Content-Type: application/json

{
  "quiz": {
    "name": "Matrix"
  }
}
```

### Deleting quizzes

```http
DELETE /quizzes/1 HTTP/1.1
Authorization: Token token="abc123"
```

This will delete the quiz and its associated questions.

## Questions

| Attribute  | Type    |
| ---------  | ------  |
| `type`     | string  |
| `title`    | string  |
| `content`  | JSON    |
| `hint`     | string  |
| `position` | integer |

### Retrieving questions

When you retrieve a single quiz, questions will be automatically included.
Include the authorization token if you want to search only authorized user's
quizzes.

```http
GET /quizzes/12 HTTP/1.1
Authorization: Token token="abc123"
```
```http
GET /quizzes/12 HTTP/1.1
```
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "quiz": {
    "name": "Game of Thrones",
    "category": "movies",
    "questions": [
      {"id": 31, "type": "boolean", "title": "..."},
      {"id": 32, "type": "choice", "title": "..."}
    ]
  }
}
```

### Creating questions

When creating a quiz, you can also include `questions_attributes` in quiz' data.

```http
POST /quizzes HTTP/1.1
Content-Type: application/json

{
  "quiz": {
    "name": "Game of Thrones",
    "category": "movies",
    "questions_attributes": [
      {"type": "boolean", "title": "..."},
      {"type": "choice", "title": "..."}
    ]
  }
}
```

### Updating questions

When updating a quiz, you can also include `questions_attributes` in quiz' data
to update its questions.

```http
PUT /quizzes/23 HTTP/1.1
Content-Type: application/json

{
  "quiz": {
    "questions_attributes": [
      {"title": "..."},
      {"id": 1, "title": "..."},
      {"id": 2, "_delete": true}
    ]
  }
}
```

* If a question doesn't have an ID, it will be **created**.
* If a question does have an ID, it will be **updated**.
* If a question has an ID and `"_delete": true`, it will be **deleted**.
