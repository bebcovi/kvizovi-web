require "date"

namespace :users do
  task :store_last_activity => :environment do
    if Date.today.monday?
      [School, Student].each do |user_class|
        user_class.find_each do |user|
          user.update_column(:last_activity, LastActivity.for(user).read)
        end
      end
    end
  end
end
