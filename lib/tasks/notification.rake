namespace :notification do
  task :generate do
    if ENV["NAME"].nil?
      raise "Usage: rake notification:generate NAME=validation_on_quiz_activation"
    end

    path = "#{Rails.root}/app/views/notifications/index"
    name = ENV["NAME"]
    last_id = Dir["#{path}/*.md.erb"].map { |filename| filename.split("/").last[/^\d+/].to_i }.max || 0
    filename = "#{last_id + 1}_#{name}.md.erb"

    touch File.join(path, filename)
  end
end
