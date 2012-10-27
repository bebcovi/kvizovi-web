require "erb"

module NotificationsHelper
  def notifications
    collection = Dir["#{Rails.root}/app/views/notifications/index/*.md.erb"].map do |filename|
      ERB.new(File.read(filename)).result(binding)
    end

    collection.paginate(per_page: 4, page: params[:page])
  end
end
