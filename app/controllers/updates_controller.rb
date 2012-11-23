require "erb"

class UpdatesController < ApplicationController
  def index
    current_user.update_attributes(notified: true)
    flash.delete(:announcement)

    @updates = Dir["#{Rails.root}/app/views/updates/index/*.md.erb"].sort.reverse.
      map { |filename| ERB.new(File.read(filename)).result(binding) }.
      paginate(page: params[:page], per_page: 4)
  end

  def hide
    current_user.update_attributes(notified: true)
    redirect_to :back
  end
end
