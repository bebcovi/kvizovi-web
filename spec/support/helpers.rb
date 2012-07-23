module Helpers
  def parse_json(string)
    Yajl::Parser.parse(string)
  end
end
