class NotificationsController < ApplicationController
  def index
    current_school.update_attributes(notified: true)
    flash.delete(:notification)
  end
end
