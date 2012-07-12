module InputCollectionInput
  def input_collection(attribute, options = {})
    name = "#{object_name}[#{attribute}][]"
    (1..options.delete(:times)).inject("".html_safe) do |string, i|
      string + input(attribute, options.merge(:label => "#{options[:label]} #{i}", :input_html => {:name => name}))
    end
  end
end

SimpleForm::FormBuilder.send(:include, InputCollectionInput)
