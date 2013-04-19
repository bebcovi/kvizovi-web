namespace :paper_trail do
  task :remove_old_versions => :environment do
    ImageQuestion.class_eval do
      def destroy_attached_files
        super
      end
    end

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
