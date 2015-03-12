# Introduction

All requests should be sent and all responses are returned as JSON.

```http
GET /account HTTP/1.1
Content-Type: application/json

{"user": {"email": "janko.marohnic@gmail.com", "password": "secret"}}
```

When a request is not successful, the appropriate response status will be
returned, often following up with an error message.

```http
HTTP/1.1 400 Bad Request
Content-Type: application/json

{"errors": ["Invalid email or password"]}
```

The errors will be either

* generic: `{"errors": ["Invalid email or password"]}`, or
* specific: `{"errors": {"user": {"email": ["is already taken"]}}`.

To make authorized requests, include user's token in the "Authorization"
header.

```http
GET /quizzes HTTP/1.1
Authorization: Token token="abc123"
```

# Account

## Registration

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
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "user": {
    "id": 32,
    "nickname": "Junky",
    "email": "janko.marohnic@gmail.com",
    "token": "abc123"
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

## Authentication

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
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "user": {
    "id": 32,
    "nickname": "Junky",
    "email": "janko.marohnic@gmail.com",
    "token": "abc123"
  }
}
```

## Password reset

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

## Updating account

```http
PUT /account HTTP/1.1
Authorization: Token token="abc123"
Content-Type: application/json

{"user": {"old_password": "secret", "password": "new secret"}}
```

## Deleting account

```http
DELETE /account HTTP/1.1
Authorization: Token token="abc123"
```

# Quizzes & Questions

## Viewing

```http
GET /quizzes HTTP/1.1
Authorization: Token token="abc123"
```

This returns all quizzes of the authorized user, without questions included.

```http
GET /quizzes/1 HTTP/1.1
Authorization: Token token="abc123"
```

This returns a single quiz, with questions included.

## Creating

```http
POST /quizzes HTTP/1.1
Authorization: Token token="abc123"
Content-Type: application/json

{
  "quiz": {
    "name": "Game of Thrones",
    "questions": [
      {
        "type": "boolean",
        "category": "movies",
        "title": "Stannis won the battle at Blackwater Bay",
        "content": {"answer": false},
        "hint": "...",
        "position": 1
      }
    ]
  }
}
```

| Attribute  | Constraint | Description                                  |
| ---------  | ---------- | -----------                                  |
| `type`     | required   | Should be boolean/choice/association/text    |
| `category` | required   | What field is the question from              |
| `title`    | required   | The text of the question                     |
| `content`  | required   | This can be anything you want                |
| `hint`     | optional   |                                              |
| `position` | required   | The position of the question inside the quiz |

## Updating

```http
PUT /quizzes/1 HTTP/1.1
Authorization: Token token="abc123"
Content-Type: application/json

{
  "quiz": {
    "name": "Game of Thrones",
    "questions": [
      {
        "id": 1,
        "type": "boolean",
        "category": "movies",
        "title": "Stannis won the battle at Blackwater Bay",
        "content": {"answer": false},
        "hint": "...",
        "position": 1
      }
    ]
  }
}
```

Updating works the same way as creating. When you include `"questions"`, you
are effectively assigning them to the quiz:

* If you include the ID of the question, then the existing question will be
  updated (this is preferred in order to avoid recreating all questions on each
  quiz save).
* If the ID is missing, that question is created.
* Any existing question that is missing from the array will be deleted.

## Deleting

```http
DELETE /quizzes/1 HTTP/1.1
Authorization: Token token="abc123"
```

This will delete the quiz and its associated questions.
