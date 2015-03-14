require "refile"
require "uri"

Refile.cache = Refile::Backend::FileSystem.new(Dir.tmpdir)
Refile.store = Refile::Backend::FileSystem.new(Dir.tmpdir)

module Refile
  module Sequel
    module Attachment
      include Refile::Attachment

      def attachment(name, raise_errors: false, **options)
        super # includes a module

        attacher = "#{name}_attacher"

        attachment_module = ancestors[1]
        attachment_module.class_eval do
          define_method(:"#{name}=") do |value|
            value = value[:tempfile] if value.is_a?(Hash)
            send(attacher).set(value)
          end

          define_method(:validate) do
            super()
            if send(attacher).present?
              send(attacher).valid?
              send(attacher).errors.each do |error|
                errors.add(name, error)
              end
            end
          end

          define_method(:before_save) do
            super()
            send(attacher).store!
          end

          define_method(:after_destroy) do
            super()
            send(attacher).delete!
          end

          define_method(:"#{name}_url") do
            url = Refile.attachment_url(self, name, :fit, "*", "*")
            url = url.sub("*", "{width}").sub("*", "{height}") if url
            url
          end
        end
      end
    end
  end
end
