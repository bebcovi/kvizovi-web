require "kvizovi/models/base"
require "kvizovi/configuration/refile"

module Kvizovi
  module Models
    class Question < Base
      many_to_one :quiz

      dataset_module do
        def search(query)
          where {
            (title =~ /#{query}/i) |
            (content.cast(:text) =~ /#{query}/i)
          }
        end
      end

      extend Refile::Sequel::Attachment
      attachment :image
    end
  end
end
