require "json"

module Kvizovi
  module Utils
    module_function

    def paginate(dataset, page)
      page_number = Integer(page[:number] || 1)
      page_size   = Integer(page[:size])

      dataset.paginate(page_number, page_size)
    end

    def dump_json(data, env)
      if ENV["RACK_ENV"] == "production"
        JSON.generate(data)
      else
        JSON.pretty_generate(data)
      end
    end

    def resource(params, name)
      data = require_param(params, :data)
      attributes = data.fetch(:attributes)

      links = data.fetch(:links, {})
      links.inject({}) do |hash, (name, info)|
        attributes[:associations] ||= {}
        if Hash === info[:linkage]
          attributes[:associations].update(name => info[:linkage][:id])
        else
          attributes[:associations].update(name => info[:linkage].map { |rel| rel[:id] })
        end
      end

      attributes
    end

    def require_param(params, name)
      params.fetch(name)
    rescue KeyError
      raise Kvizovi::Error::MissingParam, name
    end
  end
end
