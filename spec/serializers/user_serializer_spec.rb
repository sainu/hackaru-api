# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  describe '#to_json' do
    let(:user) { create(:user) }

    subject do
      serializer = UserSerializer.new(user)
      ActiveModelSerializers::Adapter.create(serializer).to_json
    end

    it 'returns json' do
      user_setting = user.user_setting
      is_expected.to be_json_eql({
        id: user.id,
        email: user.email,
        user_setting: {
          receive_week_report: user_setting.receive_week_report,
          receive_month_report: user_setting.receive_month_report
        }
      }.to_json)
    end
  end
end
