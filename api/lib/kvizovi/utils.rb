module Kvizovi
  module Utils
    module_function

    def extract_relationship_links(attributes)
      links = attributes.delete(:links)
      links.inject({}) do |hash, (name, info)|
        if Hash === info[:linkage]
          hash.update(name => info[:linkage][:id])
        else
          hash.update(name => info[:linkage].map { |rel| rel[:id] })
        end
      end
    end

    def paginate(dataset, page)
      page_number = Integer(page[:number] || 1)
      page_size   = Integer(page[:size])

      dataset.paginate(page_number, page_size)
    end
  end
end
