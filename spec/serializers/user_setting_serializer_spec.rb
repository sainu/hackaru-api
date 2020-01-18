# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSettingSerializer, type: :serializer do
  describe '#to_json' do
    let(:user_setting) { create(:user_setting) }

    subject do
      serializer = UserSettingSerializer.new(user_setting)
      ActiveModelSerializers::Adapter.create(serializer).to_json
    end

    it 'returns json' do
      is_expected.to be_json_eql({
        receive_week_report: user_setting.receive_week_report,
        receive_month_report: user_setting.receive_month_report
      }.to_json)
    end
  end
end
