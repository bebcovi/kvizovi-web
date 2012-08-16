module InputCollectionInput
  def input_collection(attribute, options = {})
    name = "#{object_name}[#{attribute}][]"
    label = options.delete(:labels) || I18n.t("simple_form.labels.#{object_name.gsub(/\[([^\]]+)\]/, '.\1')}.#{attribute}")
    values = options.delete(:values) || []
    (1..options.delete(:times)).inject("".html_safe) do |string, i|
      string + input(attribute, options.merge(label: "#{label} #{i}", input_html: {name: name, value: values[i - 1]}))
    end
  end
end

SimpleForm::FormBuilder.send(:include, InputCollectionInput)
