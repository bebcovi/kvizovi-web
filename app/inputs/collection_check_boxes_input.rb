class CollectionCheckBoxesInput < SimpleForm::Inputs::CollectionCheckBoxesInput
  protected

  def apply_nested_boolean_collection_options!(options)
  end

  def build_nested_boolean_style_item_tag(collection_builder)
    collection_builder.label do
      collection_builder.check_box + collection_builder.text
    end
  end
end
