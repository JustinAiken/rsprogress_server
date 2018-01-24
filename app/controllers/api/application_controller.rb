module API
  class ApplicationController < ActionController::API

    respond_to :json

    # Le hack!
    InheritedResources::Base.inherit_resources self
    initialize_resources_class_accessors!
    create_resources_url_helpers!
    # /hack

    before_action :authenticate_user_from_token!

  protected

    alias_method :devise_current_user,    :current_user
    alias_method :devise_user_signed_in?, :user_signed_in?

    def current_user
      return nil if token_from_request.blank?
      authenticate_user_from_token!
    end

    def user_signed_in?
      !current_user.nil?
    end

    def authenticate_user_from_token!
      if claims && user = User.find_by(email: claims[0]['user'])
        @current_user = user
      else
        render_unauthorized
      end
    end

    def claims
      JWT.decode(token_from_request, ENV["JWT_KEY"], true)
    rescue
      nil
    end

    # https://labs.chiedo.com/blog/setting-up-javascript-web-tokens-using-the-jwt-gem-with-devise-for-a-rails-4-site/ <-
    def jwt_token(user)
      JWT.encode({user: user[:email], exp: Time.now.to_i + 2.weeks}, ENV["JWT_KEY"], 'HS256')
    end

    def render_unauthorized(payload = { errors: { unauthorized: ["You are not authorized perform this action."] } })
      render json: payload.merge(response: { code: 401 }), status: 401
    end

    def token_from_request
      auth_header = request.headers['Authorization']
      token       = auth_header.split(' ').last rescue nil
      token       = request.parameters["token"] if token.to_s.empty?
      token
    end
  end
end
