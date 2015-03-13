require "kvizovi/configuration/sequel"
require "kvizovi/models/user"

module Kvizovi
  module Models
    class Quiz < Sequel::Model
      many_to_one :creator, class: User
      one_to_many :questions, order: :position

      add_association_dependencies questions: :delete

      dataset_module do
        def newest
          order(Sequel.desc(:updated_at))
        end
      end

      nested_attributes :questions

      def questions_count
        questions_dataset.count
      end

      def to_json(**options)
        super(
          only: [:id, :name, :image, :questions_count, :created_at, :updated_at],
          include: [:creator, *(:questions if options[:root])],
          **options,
        )
      end
    end
  end
end
