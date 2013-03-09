require "haml"
require_relative "../../lib/markdown_rendering"

module Haml
  module Filters

    remove_filter "Markdown"

    module Markdown
      include Base

      def render(text)
        MarkdownRendering.markdown(text)
      end
    end

  end
end
