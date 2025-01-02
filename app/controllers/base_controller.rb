class BaseController < ActionController::API
  include ActionController::Serialization
  include ApiBaseAction
  before_action :authenticate!

  protected

  def current_user
    @current_user ||= User.find_by(id: user_id)
  end
end
