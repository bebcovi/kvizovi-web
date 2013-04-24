module PaperTrailHelpers
  extend ActiveSupport::Concern

  module ClassMethods
    def enable_paper_trail!
      before(:all) { PaperTrail.enabled = true }
      after(:all)  { PaperTrail.enabled = false }
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) { PaperTrail.enabled = false }
  config.after(:suite) { PaperTrail.enabled = true }
  config.include PaperTrailHelpers
end
