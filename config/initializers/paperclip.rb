class ActiveRecord::Base
  class << self
    alias normal_has_attached_file has_attached_file
    def has_attached_file(name, options = {})
      if not Rails.env.production?
        normal_has_attached_file(name, options)
      else
        dropbox_options = {
          storage: :dropbox,
          dropbox_credentials: "#{Rails.root}/config/dropbox.yml"
        }
        normal_has_attached_file(name, dropbox_options.merge(options))
      end
    end
  end
end
