RSpec::Matchers.define :appear_before do |other_content|
  match do |content|
    page.body.index(content) < page.body.index(other_content)
  end
end
