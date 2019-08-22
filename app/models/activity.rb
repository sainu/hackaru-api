# frozen_string_literal: true

class Activity < ApplicationRecord
  include Webhookable

  belongs_to :user
  belongs_to :project, optional: true

  validates :started_at, presence: true
  validates :description, length: { maximum: 500 }
  validate :project_is_invalid
  validate :stopped_at_cannot_be_before_started_at

  before_save :set_duration
  before_save :stop_other_workings, unless: -> { stopped_at.present? }

  scope :between, lambda { |from, to|
    where('started_at <= ? and ? <= stopped_at', to, from)
  }

  after_commit :deliver_stopped_webhooks, on: %i[update]

  def deliver_stopped_webhooks
    prevs = previous_changes[:stopped_at]
    return unless stopped_at.present? && prevs.present? && prevs.first.nil?

    deliver_webhooks 'stopped'
  end

  def set_duration
    self.duration = stopped_at.present? ? stopped_at - started_at : nil
  end

  def stop_other_workings
    workings = user.activities.where(stopped_at: nil)
    workings.where.not(id: id).update(stopped_at: Time.zone.now)
  end

  def to_suggestion
    Suggestion.new(
      project: project,
      description: description
    )
  end

  def self.to_suggestions
    includes(:project)
      .select(:description, :project_id)
      .distinct
      .map(&:to_suggestion)
  end

  def self.working
    find_by(stopped_at: nil)
  end

  private

  def project_is_invalid
    return if project_id.nil? || user.projects.exists?(id: project_id)

    errors.add(:project, :is_invalid)
  end

  def stopped_at_cannot_be_before_started_at
    return if started_at.nil? || stopped_at.nil? || stopped_at >= started_at

    errors.add(:stopped_at, :cannot_be_before_started_at)
  end
end
