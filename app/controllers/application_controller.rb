class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper_method :power_user
  helper_method :moderator_user

  def new_session_path(scope)
    new_user_session_path
  end

  def power_user
    current_user.score > 25
  end

  def moderator_user
    current_user.score > 50
  end
end
