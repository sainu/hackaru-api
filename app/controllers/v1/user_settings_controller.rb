# frozen_string_literal: true

module V1
  class UserSettingsController < ApplicationController
    before_action only: %i[update] do
      authenticate_user!
    end

    def update
      current_user.user_setting.update!(user_setting_params)
      render json: current_user.user_setting
    end

    private

    def user_setting_params
      params.require(:user_setting).permit(
        :receive_week_report,
        :receive_month_report,
      )
    end
  end
end
