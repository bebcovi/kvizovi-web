class CollectionRadioButtonsInput < SimpleForm::Inputs::CollectionRadioButtonsInput
  protected

  def apply_nested_boolean_collection_options!(options)
  end

  def build_nested_boolean_style_item_tag(collection_builder)
    collection_builder.label do
      collection_builder.radio_button + collection_builder.text
    end
  end
end
