module ApiFlashcards
  module V1
    class CardsController < ApplicationController
      before_action :authenticate

      # Show user cards
      # GET request 'v1/cards'
      # @return [JSON]
      def index
        cards = current_user.cards
        render json: cards, status: 200
      end

      # Create new card
      # POST request 'v1/cards'
      # @param [JSON] "{card: {original_text: 'cat', translated_text: 'кот', block_id: 1}}"
      # @return [JSON]
      def create
        card = current_user.cards.build(card_params)
        if card.save
          render json: card, status: 201
        else
          render json: { errors: card.errors.full_messages, status: 400 }
        end
      end

      private

      # Basic Authentication
      # @example header: '{"AUTHORIZATION"=>"Basic cGVyc29uMTI4QGV4YW1wbGUuY29tOjEyMzQ3"}'
      def authenticate
        authenticate_or_request_with_http_basic do |email, password|
          user = User.find_by_email(email)
          @current_user = user if user&.valid_password?(password)
        end
      end

      def card_params
        params.require(:card).permit(:original_text, :translated_text, :block_id)
      end
    end
  end
end
