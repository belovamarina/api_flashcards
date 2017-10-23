module ApiFlashcards
  module V1
    class TrainerController < ApplicationController
      before_action :authenticate

      # Show random card
      # GET request 'v1/trainer'
      # @return [JSON]
      def index
        card = random_card
        render json: card, status: 200
      end

      # Review card
      # PUT request 'v1/review_card'
      # @param "{ user_translation: 'cat' }"
      # @return [JSON] { state: true } if correct translation
      def review_card
        card = current_user.cards.find(trainer_params[:card_id])
        check_result = card.check_translation(trainer_params[:user_translation])
        render json: { state: check_result[:state] }, status: 200
      end

      private

      # Basic Authentication
      # @example header: {"AUTHORIZATION"=>"Basic cGVyc29uMTI4QGV4YW1wbGUuY29tOjEyMzQ1"}
      def authenticate
        authenticate_or_request_with_http_basic do |email, password|
          user = User.find_by_email(email)
          @current_user = user if user&.valid_password?(password)
        end
      end

      def trainer_params
        params.permit(:user_translation, :card_id)
      end

      def random_card
        if current_user.current_block
          current_user.current_block.cards.pending.first || current_user.current_block.cards.repeating.first
        else
          current_user.cards.pending.first || current_user.cards.repeating.first
        end
      end
    end
  end
end
