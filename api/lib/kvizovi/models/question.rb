require "sequel"

module Kvizovi
  module Models
    class Question < Sequel::Model
      many_to_one :quiz

      def to_json(**options)
        super(
          only: [:id, :type, :category, :title, :content, :image, :hint, :position],
          **options
        )
      end
    end
  end
end
