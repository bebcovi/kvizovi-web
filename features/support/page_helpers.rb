module PageHelpers
  def path_to(page)
    case page
    when /homepage/
      root_url
    when /login page/
      login_url(subdomain: @user_type)
    when /my profile page/
      profile_url(subdomain: @user_type)
    when /quizzes page/
      quizzes_url(subdomain: @user_type)
    when /questions page/
      quiz_questions_url(@quiz, subdomain: @user_type)
    when /page for playing quizzes/
      choose_quiz_url(subdomain: @user_type)
    else raise "Page isn't recognized: #{page}"
    end
  end
end

World(PageHelpers)
