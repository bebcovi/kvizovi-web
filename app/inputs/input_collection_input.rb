module InputCollectionInput
  def input_collection(attribute, options = {})
    name = "#{object_name}[#{attribute}][]"
    label = options.delete(:labels) || I18n.t("simple_form.labels.#{object_name.gsub(/\[([^\]]+)\]/, '.\1')}.#{attribute}")
    values = options.delete(:values) || []
    options.delete(:indices).inject("".html_safe) do |string, i|
      string + self.label(attribute, "#{label} #{i}", for: "#{object_name}_#{attribute}_#{i}") +
        self.input(attribute, options.merge(label: false, input_html: {name: name, value: values[i - 1], id: "#{object_name}_#{attribute}_#{i}"}))
    end
  end
end

SimpleForm::FormBuilder.send(:include, InputCollectionInput)
