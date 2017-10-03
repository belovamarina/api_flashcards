module ApiFlashcards
  class MainController < ApplicationController
    before_action :authenticate

    def index
      render json: "{\"message\":\"Welcome!\"}"
    end

    private

    def authenticate
      authenticate_or_request_with_http_basic do |email, password|
        User.find_by_email(email).valid_password?(password)
      end
    end
  end
end
