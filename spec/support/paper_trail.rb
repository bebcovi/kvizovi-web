PaperTrail.enabled = false

module PaperTrailHelpers
  extend ActiveSupport::Concern

  module ClassMethods
    def enable_paper_trail
      before(:all) { PaperTrail.enabled = true }
      after(:all)  { PaperTrail.enabled = false }
    end
  end
end

RSpec.configure do |config|
  config.include PaperTrailHelpers
end
