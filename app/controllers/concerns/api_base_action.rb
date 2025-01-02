# Base Controller for ApiBaseAction
module ApiBaseAction
  extend ActiveSupport::Concern


  protected

  # Authenticate access by partner app and customer access token
  def authenticate!
    if auth_token_expired?
      unauthorize!(message: "Authorization Token Expired")
    elsif current_user.blank?
      unauthorize!(message: "Account is not found")
    elsif auth_token.blank?
      unauthorize!(message: "Authorization token must be passed in headers")
    end
  end

  def validate_content_type
    unless request.content_type == "application/json"
      render json: { error: "Unsupported Content-Type" }, status: :unsupported_media_type
    end
  end

  def auth_token
    request.headers["Authorization"]
  end

  def auth_data
    user_id, user_class, time_in_utc = Utils::Crypt.decrypt(auth_token).split("/")
  end

  def user_id
    auth_data[0] if auth_data[1] == "User"
  end

  def auth_token_expired?
    auth_data[2].to_i < (Time.now.utc - ENV["AUTH_TOKEN_EXPIRY_MINS"].to_i.minutes).to_i
  end

  def validate_bid_start_and_end_time_format
    error_messages = []
    error_messages << "bid_start_time must be a valid ISO 8601 datetime" unless valid_iso8601?(params[:bid_start_time])
    error_messages << "bid_end_time must be a valid ISO 8601 datetime" unless valid_iso8601?(params[:bid_end_time])
    espond_error(error_messages: error_messages.join(","), code: :unprocessable_entity)
  end

  def valid_iso8601?(datetime)
    DateTime.iso8601(datetime.to_s)
    true
  rescue ArgumentError
    false
  end

  def render_json(payload, meta: {}, code: :ok)
    if payload.is_a?(Hash) && payload.try(:[], :errors).present?
      respond_error(error_message: payload[:errors], code: code)
    else
      render json: payload, meta: meta, root: "data", adapter: :json
    end
  end

  def respond_error(error_message: "error exception", code: :ok)
    render json: { error: error_message }, status: code
    nil
  end

  def unauthorize!(message: "unauthorize")
    respond_error(error_message: message, code: 401)
  end
end
