class String
  def prepend_icon(name)
    "<i class=\"icon-#{name}\"></i> #{self}".html_safe
  end

  def append_icon(name)
    "#{self} <i class=\"icon-#{name}\"></i>".html_safe
  end
end
