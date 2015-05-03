require "yaks"
require "rack/utils"

module Kvizovi
  module Mappers
    class DatasetMapper < Yaks::CollectionMapper
      link :next, -> { next_link }, if: -> { params.has_key?("page") }

      def call(dataset, _env = nil)
        @dataset = dataset
        super(dataset.to_a, _env = nil)
      end

      private

      def next_link
        link_to_page(@dataset.next_page) if @dataset.next_page
      end

      def link_to_page(number)
        params["page"]["number"] = number
        "#{env["PATH_INFO"]}?#{query_string}"
      end

      def query_string
        Rack::Utils.build_nested_query(params)
      end

      def params
        @params ||= Rack::Utils.parse_nested_query(env["QUERY_STRING"])
      end
    end
  end
end
