RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller

  RSpec.shared_context :authorized_user, authorized_user: ->v { v } do
    let(:api_token)     { user.present? ? API::ApplicationController.new.send(:jwt_token, user) : nil }
    let(:json_response) { JSON.parse response.body }

    case example.metadata[:authorized_user]
    when :admin    then let(:user) { create :admin_user }
    when nil       then let(:user) { nil }
    else                let(:user) { create :user }
    end

    before do |example|
      if example.metadata[:described_class].to_s =~ /API/
        request.headers['Authorization'] = "Bearer #{api_token}"
      else
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end
    end
  end
end
