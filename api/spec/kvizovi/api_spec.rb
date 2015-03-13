require "spec_helper"
require "kvizovi"
require "uri"
require "timecop"
require "pry"

Mail.defaults { delivery_method :test }
BCrypt::Engine.cost = 1

RSpec.describe Kvizovi::Api do
  include TestHelpers::Integration

  specify "registration" do
    resp = post "/account", user: attributes_for(:janko)

    expect(resp.body["user"]["id"]).not_to eq nil
  end

  specify "account confirmation" do
    post "/account", user: attributes_for(:janko)

    url = URI(sent_emails.last.body.to_s[%r{^http://.+$}])
    resp = put url.request_uri

    expect(resp.body["user"]).not_to be_empty
  end

  specify "authentication" do
    post "/account", user: attributes_for(:janko)

    resp = get "/account", user: {
      email: attributes_for(:janko)[:email],
      password: attributes_for(:janko)[:password],
    }

    expect(resp.body["user"]).not_to be_empty
  end

  specify "password reset" do
    post "/account", user: attributes_for(:janko)

    post "/account/password", user: {email: attributes_for(:janko)[:email]}
    url = URI(sent_emails.last.body.to_s[%r{^http://.+$}])
    resp = put url.request_uri, user: {password: "another secret"}

    expect(resp.body["user"]).not_to be_empty

    resp = get "/account", user: {
      email: attributes_for(:janko)[:email],
      password: "another secret",
    }

    expect(resp.status).to eq 200
  end

  specify "password update" do
    resp = post "/account", user: attributes_for(:janko)

    resp = put "/account",
      {user: {old_password: attributes_for(:janko)[:password], password: "new secret"}},
      {"Authorization" => %(Token token="#{resp.body["user"]["token"]}")}

    resp = get "/account", user: {
      email: attributes_for(:janko)[:email],
      password: "new secret",
    }

    expect(resp.status).to eq 200
  end

  specify "deleting account" do
    resp = post "/account", user: attributes_for(:janko)

    delete "/account", {},
      {"Authorization" => %(Token token="#{resp.body["user"]["token"]}")}

    resp = get "/account", user: {
      email: attributes_for(:janko)[:email],
      password: attributes_for(:janko)[:password],
    }

    expect(resp.status).to eq 401
  end


  specify "proper unauthorized resp" do
    resp = post "/account", user: attributes_for(:janko)
    token = resp.body["user"]["token"]

    resp = get "/quizzes"
    expect(resp.status).to eq 401

    resp = get "/quizzes", {}, {"Authorization" => "foo"}
    expect(resp.status).to eq 401
  end


  specify "managing quizzes" do
    resp = post "/account", user: attributes_for(:janko)
    authorization = {"Authorization" => %(Token token="#{resp.body["user"]["token"]}")}

    resp = post "/quizzes",
      {quiz: attributes_for(:quiz,
        questions_attributes: [attributes_for(:question)])}, authorization
    expect(resp.body["quiz"]).not_to be_empty
    expect(resp.body["quiz"]["questions"]).to be_a_nonempty(Array)

    quiz_id = resp.body["quiz"]["id"]

    resp = get "/quizzes/#{quiz_id}", {}, authorization
    expect(resp.body["quiz"]).not_to be_empty
    expect(resp.body["quiz"]["questions"]).to be_a(Array)

    resp = put "/quizzes/#{quiz_id}", {quiz: {name: "New name"}}, authorization
    expect(resp.body["quiz"]).not_to be_empty
    expect(resp.body["quiz"]["name"]).to eq "New name"

    resp = get "/quizzes", {}, authorization
    expect(resp.body["quizzes"]).not_to be_empty
    expect(resp.body["quizzes"].first).not_to have_key("quiz")
    expect(resp.body["quizzes"].first).not_to have_key("questions")
  end
end
