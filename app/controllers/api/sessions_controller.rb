module API
  class SessionsController < ApplicationController
    skip_before_action :authenticate_user_from_token!
    before_action :ensure_params_exist

    def create
      @user = User.find_for_database_authentication(email: user_params[:email])
      return invalid_login_attempt unless @user
      return invalid_login_attempt unless @user.valid_password?(user_params[:password])
      @auth_token = jwt_token(email: @user.email)
      render json: {token: @auth_token}
    end

  private

    def user_params
      params.require(:user).permit(:email, :password)
    end

    def ensure_params_exist
      if user_params[:email].blank? || user_params[:password].blank?
        render_unauthorized errors: { unauthenticated: ["Incomplete credentials"] }
      end
    end

    def invalid_login_attempt
      render_unauthorized errors: { unauthenticated: ["Invalid credentials"] }
    end
  end
end
