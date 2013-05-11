module Admin::SchoolsHelper
  def activity(time)
    if time
      "prije #{time_ago_in_words(time)}"
    else
      "nije još zabilježena"
    end
  end
end
