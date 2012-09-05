ActiveRecord::Base.extend Module.new do
  def has_attached_file(name, options = {})
    if Rails.env.development?
      super
    else
      dropbox_options = {
        storage: :dropbox,
        dropbox_credentials: "#{Rails.root}/config/dropbox.yml"
      }
      super(name, dropbox_options.merge(options))
    end
  end
end
