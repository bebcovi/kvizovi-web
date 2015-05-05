require "integration"

require "pry"
require "mini_magick"

class AppTest < IntegrationTest
  def email
    attributes_for(:janko)[:email]
  end

  def password
    attributes_for(:janko)[:password]
  end

  def test_registration
    post "/account", data: attributes_for(:janko)
    refute_empty resource("user")

    patch email_link
    refute_empty resource("user")
  end

  def test_authentication
    post "/account", data: attributes_for(:janko)

    get "/account", {}, basic_auth(email, password)
    refute_empty resource("user")

    get "/account", {}, token_auth(resource("user")["token"])
    refute_empty resource("user")
  end

  def test_password_reset
    post "/account", data: attributes_for(:janko)

    post "/account/password?email=#{email}"
    patch email_link, data: {password: "another secret"}
    refute_empty resource("user")

    get "/account", {}, basic_auth(email, "another secret")
    refute_empty resource("user")
  end

  def test_password_update
    post "/account", data: attributes_for(:janko)

    patch "/account",
      {data: {old_password: password, password: "new secret"}},
      token_auth(resource("user")["token"])

    get "/account", {}, basic_auth(email, "new secret")
    refute_empty resource("user")
  end

  def test_deleting_account
    post "/account", data: attributes_for(:janko)

    delete "/account", {}, token_auth(resource("user")["token"])

    get "/account", {}, basic_auth(email, password)
    assert_equal 401, status
    assert_equal "credentials_invalid", error["id"]
  end

  def test_proper_unauthorized_response
    post "/account", data: attributes_for(:janko)

    patch "/account"
    assert_equal 401, status
    assert_equal "token_missing", error["id"]

    patch "/account", {}, token_auth("foo")
    assert_equal 401, status
    assert_equal "token_invalid", error["id"]
  end

  def test_managing_quizzes
    post "/account", data: attributes_for(:janko)
    authorization = token_auth(resource("user")["token"])

    post "/quizzes?include=questions,creator",
      {data: attributes_for(:quiz,
        questions_attributes: [attributes_for(:question)])}, authorization
    refute_empty resource("quiz")
    refute_empty associated_resource("quiz", "questions")
    refute_empty associated_resource("quiz", "creator")

    quiz_id = resource("quiz")["id"]

    get "/quizzes/#{quiz_id}", authorization
    refute_empty resource("quiz")

    patch "/quizzes/#{quiz_id}", {data: {name: "New name"}}, authorization
    assert_equal "New name", resource("quiz")["name"]

    get "/quizzes", {}, authorization
    refute_empty resource("quiz")
  end

  def test_gameplays
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
    refute_empty resource("gameplay")
    refute_empty associated_resource("gameplay", "players")
    refute_empty associated_resource("gameplay", "quiz")

    get "/gameplays", {as: "player"}, authorization
    refute_empty resources("gameplays")

    get "/gameplays", {as: "player", page: {number: 1, size: 1}}, authorization
    refute_empty resources("gameplays")

    get "/gameplays/#{resource("gameplay")["id"]}", {}, authorization
    refute_empty resource("gameplay")
  end

  def test_image_upload
    post_original "/account", data: attributes_for(:janko, avatar: image)
    avatar_url = resource("user").fetch("avatar_url")
    avatar_url.gsub!(/\{\w+\}/, "{width}"=>"50", "{height}"=>"50")
    avatar_path = URI(avatar_url).path

    get avatar_path

    assert_equal 200, status
    avatar = MiniMagick::Image.read(last_response.body)
    assert avatar.width <= 50
    assert avatar.height <= 50
  end

  def test_contact
    post "/contact", data: {type: "emails", from: "foo@bar.com", body: "Hello"}

    assert_includes sent_emails.last[:message], "foo@bar.com"
    assert_includes sent_emails.last[:message], "Hello"
  end

  def test_heartbeat
    head "/heartbeat"

    assert_equal 200, status
  end
end
