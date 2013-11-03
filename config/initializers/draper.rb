require "draper"

Draper::CollectionDecorator.delegate *[
  # WillPaginate methods
  :reorder, :current_page, :total_pages, :per_page,
  :offset, :total_entries
]
