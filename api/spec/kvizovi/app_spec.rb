require "spec_helper"
require "kvizovi"
require "timecop"
require "pry"
require "mini_magick"
require "uri"

RSpec.describe Kvizovi::App do
  include TestHelpers::Integration

  specify "registration" do
    post "/account", data: attributes_for(:janko)

    expect(resource("user")).not_to be_empty
  end

  specify "account confirmation" do
    post "/account", data: attributes_for(:janko)

    url = URI(sent_emails.last[:message][%r{^http://.+$}])
    patch url.request_uri

    expect(resource("user")).not_to be_empty
  end

  specify "authentication" do
    post "/account", data: attributes_for(:janko)

    get "/account", {}, basic_auth(*attributes_for(:janko).values_at(:email, :password))
    expect(resource("user")).not_to be_empty

    get "/account", {}, token_auth(resource("user")["token"])
    expect(resource("user")).not_to be_empty
  end

  specify "password reset" do
    post "/account", data: attributes_for(:janko)

    post "/account/password?email=#{attributes_for(:janko)[:email]}"
    url = URI(sent_emails.last[:message][%r{^http://.+$}])
    patch url.request_uri, data: {password: "another secret"}
    expect(resource("user")).not_to be_empty

    get "/account", {}, basic_auth(attributes_for(:janko)[:email], "another secret")
    expect(resource("user")).not_to be_empty
  end

  specify "password update" do
    post "/account", data: attributes_for(:janko)

    patch "/account",
      {data: {old_password: attributes_for(:janko)[:password], password: "new secret"}},
      token_auth(resource("user")["token"])

    get "/account", {}, basic_auth(attributes_for(:janko)[:email], "new secret")
    expect(resource("user")).not_to be_empty
  end

  specify "deleting account" do
    post "/account", data: attributes_for(:janko)

    delete "/account", {}, token_auth(resource("user")["token"])

    get "/account", {}, basic_auth(*attributes_for(:janko).values_at(:email, :password))
    expect(status).to eq 401
    expect(error["id"]).to eq "credentials_invalid"
  end


  specify "proper unauthorized response" do
    post "/account", data: attributes_for(:janko)

    patch "/account"
    expect(status).to eq 401
    expect(error["id"]).to eq "token_missing"

    patch "/account", {}, token_auth("foo")
    expect(status).to eq 401
    expect(error["id"]).to eq "token_invalid"
  end

  specify "managing quizzes" do
    post "/account", data: attributes_for(:janko)
    authorization = token_auth(resource("user")["token"])

    post "/quizzes?include=questions,creator",
      {data: attributes_for(:quiz,
        questions_attributes: [attributes_for(:question)])}, authorization
    expect(resource("quiz")).not_to be_empty
    expect(associated_resource("quiz", "questions")).not_to be_empty
    expect(associated_resource("quiz", "creator")).not_to be_empty

    quiz_id = resource("quiz")["id"]

    get "/quizzes/#{quiz_id}", authorization
    expect(resource("quiz")).not_to be_empty

    patch "/quizzes/#{quiz_id}", {data: {name: "New name"}}, authorization
    expect(resource("quiz")["name"]).to eq "New name"

    get "/quizzes", {}, authorization
    expect(resource("quiz")).not_to be_empty
  end

  specify "searching quizzes for playing" do
    post "/account", data: attributes_for(:janko)
    authorization = token_auth(resource("user")["token"])

    post "/quizzes", {data: attributes_for(:quiz, name: "Game of Thrones", category: "movies")}, authorization
    post "/quizzes", {data: attributes_for(:quiz, name: "Tulips", category: "flowers")}, authorization

    get "/quizzes", q: "Game"
    expect(resources("quizzes").count).to eq 1

    get "/quizzes", category: "movies"
    expect(resources("quizzes").count).to eq 1

    get "/quizzes", page: {number: 1, size: 1}
    expect(resources("quizzes").count).to eq 1
    expect(links).to have_key("next")
    get links["next"]
    expect(resources("quizzes").count).to eq 1
    expect(body).not_to have_key("links")

    get "/quizzes/#{resource("quiz")["id"]}"
    expect(resource("quiz")).not_to be_empty
  end

  specify "gameplays" do
    post "/account", data: attributes_for(:janko)
    authorization = token_auth(resource("user")["token"])
    user_id = resource("user")["id"]

    post "/quizzes", {data: attributes_for(:quiz)}, authorization
    quiz_id = resource("quiz")["id"]

    post "/gameplays?include=players,quiz", {
      data: attributes_for(:gameplay,
        links: {
          quiz: {linkage: {type: :quizzes, id: quiz_id}},
          players: {linkage: [{type: :users, id: user_id}]},
        }
      )
    }, authorization
    expect(resource("gameplay")).not_to be_empty
    expect(associated_resource("gameplay", "players")).not_to be_empty
    expect(associated_resource("gameplay", "quiz")).not_to be_empty

    get "/gameplays", {as: "player"}, authorization
    expect(resources("gameplays")).not_to be_empty

    get "/gameplays", {as: "player", page: {number: 1, size: 1}}, authorization
    expect(resources("gameplays")).not_to be_empty

    get "/gameplays/#{resource("gameplay")["id"]}", {}, authorization
    expect(resource("gameplay")).not_to be_empty
  end

  specify "image upload" do
    post_original "/account", data: attributes_for(:janko, avatar: image)
    avatar_url = resource("user").fetch("avatar_url")
    avatar_url.gsub!(/\{\w+\}/, "{width}"=>"50", "{height}"=>"50")
    avatar_path = URI(avatar_url).path

    get avatar_path

    expect(status).to eq 200
    avatar = MiniMagick::Image.read(last_response.body)
    expect(avatar.width).to be <= 50
    expect(avatar.height).to be <= 50
  end

  specify "contact" do
    post "/contact", data: {type: "emails", from: "foo@bar.com", body: "Hello"}

    expect(sent_emails.last[:message]).to include "foo@bar.com"
    expect(sent_emails.last[:message]).to include "Hello"
  end

  specify "heartbeat" do
    head "/heartbeat"

    expect(status).to eq 200
  end
end
