namespace :paper_trail do
  ImageQuestion = ::ImageQuestion
  ImageQuestion.class_eval do
    def destroy_attached_files
      super
    end
  end

  task :remove_old_versions => :environment do
    Version.where{created_at <= 1.week.ago}.each do |version|
      version.destroy
      if version.reify.is_a?(ImageQuestion)
        question = version.reify
        question.valid?
        question.send(:prepare_for_destroy)
        question.send(:destroy_attached_files)
      end
    end
  end
end
