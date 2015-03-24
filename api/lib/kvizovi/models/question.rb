require "kvizovi/configuration/sequel"
require "kvizovi/configuration/refile"

module Kvizovi
  module Models
    class Question < Sequel::Model
      many_to_one :quiz

      extend Refile::Sequel::Attachment
      attachment :image

      def to_json(**options)
        super(
          only: [:id, :type, :title, :content, :image, :hint, :position],
          **options
        )
      end
    end
  end
end
