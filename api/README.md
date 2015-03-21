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
* [**Played quizzes**](#played-quizzes)
  - [Saving played quizzes](#saving-played-quizzes)
  - [Retrieving played quizzes](#retrieving-played-quizzes)
* [**Images**](#images)
  - [Direct upload](#direct-upload)
* [**Contact**](#contact)

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
| `avatar`   | image   |

### Retrieving users

```http
GET /account HTTP/1.1
Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ
```
```http
GET /account HTTP/1.1
Authorization: Token token="abc123"
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
| `image`           | image   |
| `active`          | boolean |
| `questions_count` | integer |
| `created_at`      | time    |
| `updated_at`      | time    |

### Retrieving quizzes

To return quizzes from a user, make a request under `/account`:

```http
GET /account/quizzes HTTP/1.1
Authorization: Token token="abc123"
```

On the top-level you're searching all quizzes:

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
POST /account/quizzes HTTP/1.1
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
PUT /account/quizzes/1 HTTP/1.1
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
DELETE /account/quizzes/1 HTTP/1.1
Authorization: Token token="abc123"
```

This will delete the quiz and its associated questions.

## Questions

| Attribute  | Type    |
| ---------  | ------  |
| `id`       | integer |
| `type`     | string  |
| `image`    | image   |
| `title`    | string  |
| `content`  | json    |
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
POST /account/quizzes HTTP/1.1
Authorization: Token token="abc123"
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
PUT /account/quizzes/23 HTTP/1.1
Authorization: Token token="abc123"
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

## Played quizzes

| Attribute       | Type      |
| ---------       | ----      |
| `id`            | integer   |
| `quiz_id`       | integer   |
| `quiz_snapshot` | json      |
| `player_ids`    | integer[] |
| `answers`       | json      |
| `start`         | time      |
| `finish`        | time      |

### Saving played quizzes

```http
POST /played_quizzes HTTP/1.1
Content-Type: application/json

{
  "players": ["fg0d9sl", "a02hl39b"],
  "played_quiz": {
    "quiz_id": 32,
    "quiz_snapshot": {"name": "Game of Thrones", "questions": []},
    "answers": {},
    "start": "2015-03-15 01:54:19 +0100",
    "finish": "2015-03-15 01:56:19 +0100"
  }
}
```

The `"players"` key should contain an array of players' authorization tokens.

### Retrieving played quizzes

You can retrieve played quizzes as a creator (returns played quizzes that
the user created) or as a player (returns played quizzes that user played).

```http
GET /played_quizzes?as=player&quiz_id=44
Authorization: Token token="abc123"
```

```http
GET /played_quizzes?as=creator&quiz_id=44
Authorization: Token token="abc123"
```

```http
GET /played_quizzes?as=creator&page=1&per_page=10
Authorization: Token token="abc123"
```

## Images

Users, quizzes and questions can all have images attached. When you send an
attached image (e.g. as `avatar`), the response will include a URL template:

```json
{
  "user": {
    "id": 32,
    "avatar_url": "http://example.org/attachments/store/fit/{width}/{height}/more-stuff"
  }
}
```

You only need to take that string and replace `{width}` and `{height}` with
the dimensions you want.

*__Note__: First time you request an image URL, it will take some time to
process the request. So, to hide slow loading from the user, you could prefetch
the URLs (dimensions) you need in the background.*

You can also pass an image as a URL, just send `{"avatar_remote_url": "http://example.com/image.jpg"}`.

To delete an image, send `{"avatar_remove": true}`.

### Direct upload

While the above scenario works, users will have to wait for the image to upload
after submitting the form. If you want to improve the user experience, you can
add "direct uploading". Direct uploading means that the image starts uploading
in the background the moment user selects it.

For direct uploading, send a file as `file` to the endpoint:

```http
POST /attachments/cache HTTP/1.1
Content-Type: multipart/form-data
```
```http
HTTP/1.1 200 OK
Content-Type: application/json

{"id": "045m8u1tfjortr1peichiguhouc"}
```

Then, when the user submits the form, instead of the file simply send `{"id":
"..."}` as the `avatar`.

```http
POST /account HTTP/1.1
Content-Type: application/json

{
  "user": {
    "avatar": "{\"id\": \"045m8u1tfjortr1peichiguhouc\"}"
  }
}
```

You can also choose an existing solution –
[refile.js](https://github.com/refile/refile/blob/master/app/assets/javascripts/refile.js).
This requires that you have the following HTML:

```html
<form action="/account" enctype="multipart/form-data" method="post">
  <input name="user[avatar]" type="hidden">
  <input name="user[avatar]" type="file" data-direct="true" data-as="file" data-url="http://api.kvizovi.org/attachments/cache">
</form>
```

One benefit of this existing solution is that it's pure JavaScript (no jQuery),
with good cross-browser compatibility. Another one is that the file input will
automatically receive an `uploading` class during uploading. Third, and most
important, you have the following events automatically dispatched:

* `upload:start`
* `upload:progress`
* `upload:complete`
  * `upload:success`
  * `upload:failure`

## Contact

```http
POST /contact HTTP/1.1
Content-Type application/json

{"email": "foo@bar.com", body: "Hello, I have a problem..."}
```

The `email` field should be the email of the user, and it will be used in the
"Reply-To" header of the outgoing email.
