# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::UserSetting', type: :request do
  describe 'PUT /v1/user_setting' do
    let(:user_setting) { create(:user_setting) }
    let(:params) do
      {
        user_setting: {
          receive_week_report: true,
          receive_month_report: true
        }
      }
    end

    before do
      put "/v1/user_setting",
          headers: access_token_header(user_setting.user),
          params: params
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(200) }
      it { expect(user_setting.reload.receive_week_report).to be(true) }
      it { expect(user_setting.reload.receive_month_report).to be(true) }
    end

    context 'when params are missing' do
      let(:params) { {} }
      it { expect(response).to have_http_status(400) }
    end
  end
end
