module PageHelpers
  def path_to(page)
    case page
    when /homepage/                 then account_path
    when /login page/               then send("new_#{@user_type}_session_path")
    when /profile( page)?/          then account_profile_path
    when /quizzes page/             then account_quizzes_path
    when /questions page/           then account_quiz_questions_path(@quiz)
    when /page for playing quizzes/ then choose_quiz_path
    when /activity page/            then admin_schools_path
    when /survey page/              then surveys_path
    when /blog( page)?/             then blog_path
    when /posts page/               then posts_path
    else
      raise "Page isn't recognized: #{page}"
    end
  end
end

World(PageHelpers)
