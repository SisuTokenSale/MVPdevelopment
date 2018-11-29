class Event < ApplicationRecord
  OBJECT_CLASSES = %w[Customer FundingSource InvestTransaction].freeze

  validates :object_class, inclusion: { in: OBJECT_CLASSES }

  validates :topic, :resource_id, :status, :link, presence: true
  validates :uid, uniqueness: true

  before_save do
    self.uid ||= link.split('/').last if link.present?
  end

  # INFO: Init after create
  after_commit :update_related_object_status!, on: :create

  private

  def related_object
    object_class.constantize.find_by(uid: resource_id)
  end

  def update_related_object_status!
    related_object&.public_send(:"#{status}!")
  end
end
