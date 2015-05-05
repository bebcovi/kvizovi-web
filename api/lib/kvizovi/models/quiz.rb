require "kvizovi/models/base"
require "kvizovi/configuration/refile"

module Kvizovi
  module Models
    class Quiz < Base
      many_to_one :creator, class: User
      one_to_many :questions, order: :position

      dataset_module do
        def newest
          order{updated_at.desc}
        end

        def search(query)
          where {
            (name =~ /#{query}/i) |
            (id =~ Question.search(query).select(:quiz_id))
          }
        end
      end

      nested_attributes :questions

      extend Refile::Sequel::Attachment
      attachment :image

      def before_destroy
        questions_dataset.destroy
        super
      end
    end
  end
end
