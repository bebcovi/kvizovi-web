module NavigationHelpers
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
    else raise "Page isn't recognized: #{page}"
    end
  end
end

World(NavigationHelpers)
