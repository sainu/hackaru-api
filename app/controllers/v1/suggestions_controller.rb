# frozen_string_literal: true

module V1
  class SuggestionsController < ApplicationController
    before_action only: %i[index] do
      authenticate_user_or_doorkeeper! 'suggestions:read'
    end

    def index
      param! :q, String, default: ''
      param! :limit, Integer, range: 0..100, default: 50

      render json: current_user.activities.suggestions(
        query: params[:q],
        limit: params[:limit]
      )
    end
  end
end
