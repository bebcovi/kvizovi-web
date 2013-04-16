namespace :paper_trail do
  task :remove_old_versions => :environment do
    Version.where{created_at <= 1.week.ago}.destroy_all
  end
end
