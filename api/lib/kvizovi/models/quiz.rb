require "kvizovi/models/base"
require "kvizovi/models/user"
require "kvizovi/models/question"

require "kvizovi/configuration/refile"

module Kvizovi
  module Models
    class Quiz < Base
      many_to_one :creator, class: User
      one_to_many :questions, order: :position

      add_association_dependencies questions: :delete

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

      extend Refile::Sequel::Attachment
      attachment :image

      nested_attributes :questions
    end
  end
end
