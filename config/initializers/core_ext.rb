class String
  def prepend_icon(name)
    "<i class=\"icon-#{name}\"></i> #{self}".html_safe
  end
end
