class NotificationsController < ApplicationController
  def index
    school = current_user
    school.update_attributes(notified: true)
    flash.delete(:notification)
  end
end
