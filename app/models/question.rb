require "squeel"
require "acts_as_list"

class Question < ActiveRecord::Base
  CATEGORIES = %w[boolean choice association image text]
  NO_ANSWER  = "NO_ANSWER"

  belongs_to :quiz

  acts_as_list scope: :quiz
  serialize :data, Hash

  default_scope     -> { order{position.asc} }

  validates :content, presence: true

  def self.data_accessor(*keys)
    include Module.new {
      keys.each do |key|
        define_method(key) do
          (data || {})[key]
        end

        define_method("#{key}=") do |value|
          self.data = (data || {}).merge(key => value)
        end
      end

      def self.to_s
        "Data(#{keys.join(",")})"
      end
    }
  end
end
