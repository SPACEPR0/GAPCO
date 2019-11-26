class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :get_alerts
  def get_alerts
    @alert = Alert.new
  end

  def unlink_notifs_area area, new_notif
    area.recommendations.each do |recommendation|
      unlink_notifs_recommendation recommendation, new_notif
    end
    Notification.where(notifiable: area).each do |notification|
      notification.update(notifiable: new_notif)
    end
  end


  def unlink_notifs_recommendation recommendation, new_notif
    recommendation.evidences.each do |evidence|
      unlink_notifs_evidence evidence, new_notif
    end
    recommendation.goals.each do |goal|
      unlink_notifs_goal goal, new_notif
    end
    Notification.where(notifiable: recommendation).each do |notification|
      notification.update(notifiable: new_notif)
    end
  end


  def unlink_notifs_goal goal, new_notif
    Notification.where(notifiable: goal).each do |notification|
      notification.update(notifiable: new_notif)
    end
  end

  def unlink_notifs_evidence evidence, new_notif
    Notification.where(notifiable: evidence).each do |notification|
      notification.update(notifiable: new_notif)
    end
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname])
    devise_parameter_sanitizer.permit(:account_update, keys: [:firstname, :lastname])
  end

end
