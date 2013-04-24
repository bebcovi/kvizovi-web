module PageHelpers
  def path_to(page)
    if page.match(/^the /)
      return path_to(page.match(/^the /).post_match)
    end

    case page
    when "homepage"
      root_url
    when "login page"
      login_url(subdomain: @user_type)
    when "my profile page"
      profile_url(subdomain: @user_type)
    when "quizzes page"
      quizzes_url(subdomain: "school")
    when "questions page"
      quiz_questions_url(@quiz, subdomain: "school")
    when "page for playing quizzes"
      new_game_url(subdomain: "student")
    else raise "Page isn't recognized: #{page}"
    end
  end
end

World(PageHelpers)
