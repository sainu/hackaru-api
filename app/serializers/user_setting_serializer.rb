# frozen_string_literal: true

class UserSettingSerializer < ActiveModel::Serializer
  attributes :receive_week_report
  attributes :receive_month_report
end
