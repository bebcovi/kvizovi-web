module PageHelpers
  def url_to(page)
    case page
    when /homepage/
      if    school?  then quizzes_url
      elsif student? then choose_quiz_url
      else                root_url
      end
    when /login page/               then login_url
    when /profile( page)?/          then profile_url
    when /quizzes page/             then quizzes_url
    when /questions page/           then quiz_questions_url(@quiz)
    when /page for playing quizzes/ then choose_quiz_url
    when /activity page/            then admin_schools_url
    when /survey page/              then surveys_url
    when /blog( page)?/             then blog_url
    else
      raise "Page isn't recognized: #{page}"
    end
  end
end

World(PageHelpers)
