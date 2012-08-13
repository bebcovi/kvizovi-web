Dir["#{Rails.root}/app/inputs/**/*.rb"].each { |input_file| require input_file }
