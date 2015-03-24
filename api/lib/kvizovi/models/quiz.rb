require "kvizovi/configuration/sequel"
require "kvizovi/configuration/refile"

require "kvizovi/models/user"
require "kvizovi/models/question"

module Kvizovi
  module Models
    class Quiz < Sequel::Model
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
            (id =~ Question.select(:quiz_id).where {
              (title =~ /#{query}/i) |
              (content.cast(:text) =~ /#{query}/i)
            })
          }
        end
      end

      extend Refile::Sequel::Attachment
      attachment :image

      nested_attributes :questions

      def questions_count
        questions_dataset.count
      end

      def to_json(**options)
        super(
          only: [:id, :name, :category, :image, :questions_count, :created_at, :updated_at],
          include: [:creator, *(:questions if options[:root])],
          **options,
        )
      end
    end
  end
end
