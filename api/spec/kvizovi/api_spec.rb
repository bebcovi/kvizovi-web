require "spec_helper"
require "kvizovi"
require "uri"
require "timecop"

Mail.defaults { delivery_method :test }
BCrypt::Engine.cost = 1

RSpec.describe Kvizovi::Api do
  include TestHelpers::Integration

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

  specify "account expiration" do
    post "/account", user: attributes_for(:janko)

    Timecop.travel(4*24*60*60) do
      get "/account", user: {
        email: attributes_for(:janko)[:email],
        password: attributes_for(:janko)[:password],
      }
    end

    expect(body["errors"]).not_to be_empty
  end

  specify "authentication" do
    post "/account", user: attributes_for(:janko)

    get "/account", user: {
      email: attributes_for(:janko)[:email],
      password: attributes_for(:janko)[:password],
    }

    expect(body["user"]).not_to be_empty

    get "/account", user: {
      token: body["user"]["token"],
    }

    expect(body["user"]).not_to be_empty
  end

  specify "password reset" do
    post "/account", user: attributes_for(:janko)

    post "/account/password", user: {email: attributes_for(:janko)[:email]}
    url = URI(sent_emails.last.body.to_s[%r{^http://.+$}])
    put url.request_uri, user: {password: "another secret"}

    expect(body["user"]).not_to be_empty

    get "/account", user: {
      email: attributes_for(:janko)[:email],
      password: "another secret",
    }

    expect(status).to eq 200
  end

  specify "password update" do
    post "/account", user: attributes_for(:janko)

    put "/account",
      {user: {old_password: attributes_for(:janko)[:password], password: "new secret"}},
      {"HTTP_AUTHORIZATION" => %(Token token="#{body["user"]["token"]}")}

    get "/account", user: {
      email: attributes_for(:janko)[:email],
      password: "new secret",
    }

    expect(status).to eq 200
  end

  specify "deleting account" do
    post "/account", user: attributes_for(:janko)

    delete "/account", {}, {"HTTP_AUTHORIZATION" => %(Token token="#{body["user"]["token"]}")}

    get "/account", user: {
      email:    attributes_for(:janko)[:email],
      password: attributes_for(:janko)[:password],
    }

    expect(status).to eq 400
  end


  specify "proper unauthorized response" do
    post "/account", user: attributes_for(:janko)
    token = body["user"]["token"]

    get "/quizzes"
    expect(status).to eq 401

    get "/quizzes", {}, {"HTTP_AUTHORIZATION" => "foo"}
    expect(status).to eq 401
  end


  specify "managing quizzes" do
    post "/account", user: attributes_for(:janko)
    authorization = {"HTTP_AUTHORIZATION" => %(Token token="#{body["user"]["token"]}")}

    post "/quizzes", {quiz: {name: "Game of Thrones", questions: [{}]}}, authorization
    expect(body["quiz"]).not_to be_empty
    expect(body["quiz"]).to have_key("questions")

    quiz_id = body["quiz"]["id"]

    get "/quizzes/#{quiz_id}", {quiz: {name: "Game of thrones"}}, authorization
    expect(body["quiz"]).not_to be_empty
    expect(body["quiz"]).to have_key("questions")

    put "/quizzes/#{quiz_id}", {quiz: {name: "New name"}}, authorization
    expect(body["quiz"]).not_to be_empty
    expect(body["quiz"]["name"]).to eq "New name"

    get "/quizzes", {}, authorization
    expect(body["quizzes"]).not_to be_empty
    expect(body["quizzes"].first).not_to have_key("quiz")
    expect(body["quizzes"].first).not_to have_key("questions")
  end
end
