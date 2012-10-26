# encoding: utf-8

module AdminHelper
  def enumerate(name, count)
    t("misc.#{name}", count: count)
  end

  def activity(time)
    if time
      "prije #{time_ago_in_words(time)}"
    else
      "nije još zabilježena"
    end
  end
end
