class NotificationsController < ApplicationController
  before_action :authenticate_user!
  layout "areas_layout"

  def index
    @notifications = Notification.where(recipient: current_user)
  end

  def remove_all
    @notifications = Notification.where(recipient: current_user)
    @notifications.each do |notification|
      notification.delete
    end
    respond_to do |format|
      format.html { redirect_to  notifications_show_url}
      format.json { head :no_content }
    end
  end

  def mark_as_read
    Notification.where(recipient: current_user).each do |notification|
      notification.update(read_at: Time.zone.now)
    end
    head :no_content
  end

end
