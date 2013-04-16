module PaperclipUndoable
  extend ActiveSupport::Concern

  included do
    data_accessor :image_file_name_copy

    before_validation :use_image_file_name_copy, on: :create
    before_save       :store_image_file_name_copy

    define_method(:destroy_attached_files) do
      # Don't delete the attachments
    end
  end

  private

  def store_image_file_name_copy
    self.image_file_name_copy = image_file_name
  end

  def use_image_file_name_copy
    self.image_file_name ||= image_file_name_copy
  end
end
