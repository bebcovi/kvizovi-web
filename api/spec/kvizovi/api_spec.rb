require "spec_helper"

require "kvizovi"

require "timecop"
require "pry"
require "mini_magick"

require "logger"
require "uri"
require "base64"

Mail.defaults { delivery_method :test }
BCrypt::Engine.cost = 1
Refile.logger = Logger.new(nil)

RSpec.describe Kvizovi::API do
  include TestHelpers::Integration

  def token_auth(token)
    {"HTTP_AUTHORIZATION" => "Token token=\"#{token}\""}
  end

  def basic_auth(username, password)
    encoded_login = ["#{username}:#{password}"].pack("m*")
    {"HTTP_AUTHORIZATION" => "Basic #{encoded_login}"}
  end

  specify "registration" do
    post "/account", user: attributes_for(:janko)

    expect(body["user"]["id"]).not_to eq nil
  end

  specify "account confirmation" do
    post "/account", user: attributes_for(:janko)

    url = URI(sent_emails.last.body.to_s[%r{^http://.+$}])
    put url.request_uri

    expect(body["user"]).not_to be_empty
  end

  specify "authentication" do
    post "/account", user: attributes_for(:janko)

    get "/account", {}, basic_auth(attributes_for(:janko)[:email], attributes_for(:janko)[:password])
    expect(body["user"]).not_to be_empty

    get "/account", {}, token_auth(body["user"]["token"])
    expect(body["user"]).not_to be_empty
  end

  specify "password reset" do
    post "/account", user: attributes_for(:janko)

    post "/account/password", user: {email: attributes_for(:janko)[:email]}
    url = URI(sent_emails.last.body.to_s[%r{^http://.+$}])
    put url.request_uri, user: {password: "another secret"}
    expect(body["user"]).not_to be_empty

    get "/account", {}, basic_auth(attributes_for(:janko)[:email], "another secret")
    expect(status).to eq 200
  end

  specify "password update" do
    post "/account", user: attributes_for(:janko)

    resp = put "/account",
      {user: {old_password: attributes_for(:janko)[:password], password: "new secret"}},
      token_auth(body["user"]["token"])

    get "/account", {}, basic_auth(attributes_for(:janko)[:email], "new secret")
    expect(status).to eq 200
  end

  specify "deleting account" do
    post "/account", user: attributes_for(:janko)

    delete "/account", {}, token_auth(body["user"]["token"])

    get "/account", {}, basic_auth(attributes_for(:janko)[:email], attributes_for(:janko)[:password])
    expect(status).to eq 401
  end


  specify "proper unauthorized response" do
    post "/account", user: attributes_for(:janko)

    put "/account"
    expect(status).to eq 401

    put "/account", {}, {"HTTP_AUTHORIZATION" => "foo"}
    expect(status).to eq 401
  end

  specify "managing quizzes" do
    post "/account", user: attributes_for(:janko)
    authorization = token_auth(body["user"]["token"])

    post "/quizzes",
      {quiz: attributes_for(:quiz,
        questions_attributes: [attributes_for(:question)])}, authorization
    expect(body["quiz"]).not_to be_empty
    expect(body["quiz"]["questions"]).to be_a_nonempty(Array)

    quiz_id = body["quiz"]["id"]

    get "/quizzes/#{quiz_id}", {}, authorization
    expect(body["quiz"]).not_to be_empty
    expect(body["quiz"]["questions"]).to be_a(Array)

    put "/quizzes/#{quiz_id}", {quiz: {name: "New name"}}, authorization
    expect(body["quiz"]).not_to be_empty
    expect(body["quiz"]["name"]).to eq "New name"

    get "/quizzes", {}, authorization
    expect(body["quizzes"]).not_to be_empty
    expect(body["quizzes"].first).not_to have_key("quiz")
    expect(body["quizzes"].first).not_to have_key("questions")
  end

  specify "searching quizzes for playing" do
    post "/account", user: attributes_for(:janko)
    authorization = token_auth(body["user"]["token"])

    post "/quizzes", {quiz: attributes_for(:quiz, name: "Game of Thrones", category: "movies")}, authorization
    post "/quizzes", {quiz: attributes_for(:quiz, name: "Tulips", category: "flowers")}, authorization

    get "/quizzes", q: "Game"
    expect(body["quizzes"].count).to eq 1

    get "/quizzes", category: "movies"
    expect(body["quizzes"].count).to eq 1

    get "/quizzes", page: 1, per_page: 1
    expect(body["quizzes"].count).to eq 1

    get "/quizzes/#{body["quizzes"][0]["id"]}"
    expect(body["quiz"]).not_to be_empty
    expect(body["quiz"]["questions"]).to be_a(Array)
  end

  specify "played quizzes" do
    post "/account", user: attributes_for(:janko)
    authorization = token_auth(body["user"]["token"])
    token = body["user"]["token"]

    post "/quizzes", {quiz: attributes_for(:quiz)}, authorization
    quiz_id = body["quiz"]["id"]

    post "/played_quizzes", {
      players: [token],
      played_quiz: attributes_for(:played_quiz, quiz_id: quiz_id)
    }
    expect(body["played_quiz"]).not_to be_empty
    expect(body["played_quiz"]["players"]).not_to be_empty

    get "/played_quizzes", {as: "player"}, authorization
    expect(body["played_quizzes"]).not_to be_empty

    get "/played_quizzes", {as: "player", page: 1, per_page: 1}, authorization
    expect(body["played_quizzes"]).not_to be_empty
  end

  specify "image upload" do
    post_original "/account", user: attributes_for(:janko, avatar: image)
    avatar_url = body["user"].fetch("avatar_url")
    avatar_url.gsub!(/\{\w+\}/, "{width}"=>"50", "{height}"=>"50")
    avatar_path = URI(avatar_url).path

    get avatar_path

    expect(last_response.status).to eq 200
    avatar = MiniMagick::Image.read(last_response.body)
    expect(avatar.width).to be <= 50
    expect(avatar.height).to be <= 50
  end
end
