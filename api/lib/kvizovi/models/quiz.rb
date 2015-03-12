require "sequel"

module Kvizovi
  module Models
    class Quiz < Sequel::Model
      many_to_one :creator, class: User
      one_to_many :questions, order: :position

      dataset_module do
        def newest
          order(Sequel.desc(:updated_at))
        end
      end

      def to_json(**options)
        super(
          only: [:id, :name, :image, :created_at, :updated_at],
          include: [:creator, *(:questions if options[:root])],
          **options,
        )
      end
    end
  end
end
