class UsersController < ActionController::API
  include ApiBaseAction
  before_action :validate_content_type, only: [ :sign_up, :sign_in ]
  before_action :set_user, only: %i[ sign_in ]

  # POST /users/sign_up
  def sign_up
    user = User.new(user_params)
    user.password_digest = user.encrypt_password
    if user.save
      render_json(user, code: :created)
    else
      respond_error(error_message: user.errors.full_messages.to_sentence, code: :unprocessable_entity)
    end
  end

  # POST /users/sign_in
  def sign_in
    if @user.valid_password?(user_params[:password])
      render_json(@user.login_json)
    else
      respond_error(error_message: "Invalid Password", code: :unauthorized)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by(email: params.expect(:email))
      respond_error(error_message: "User not found with email #{params[:email]}", code: :not_found) if @user.blank?
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.permit(:name, :email, :password)
    end
end
