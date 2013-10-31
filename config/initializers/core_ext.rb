class String
  def prepend_icon(name)
    "<i class=\"icon-#{name}\"></i> #{self}".html_safe
  end

  def append_icon(name)
    "#{self} <i class=\"icon-#{name}\"></i>".html_safe
  end
end

class Hash
  def merge_class!(css_class)
    self[:class] = [css_class, self[:class]].reject(&:blank?).join(" ")
    self
  end

  def merge_class(css_class)
    dup.merge_class!(css_class)
  end
end
