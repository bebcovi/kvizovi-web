require "delegate"

class BaseExhibit < SimpleDelegator
  def initialize(record, context)
    @context = context
    super(record)
  end
end
