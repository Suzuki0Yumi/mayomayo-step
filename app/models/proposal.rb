class Proposal < ApplicationRecord
  belongs_to :user

  validates :goal, presence: true, length: { maximum: 500 }
  validates :feeling, presence: true, 
             inclusion: { in: %w[light_interest strong_interest blocked_action unclear_state] }
  validates :time_available, 
             inclusion: { in: %w[5min 30min 60min_plus], allow_blank: true }
  validates :suggestion, presence: true

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  scope :recent, -> { order(created_at: :desc) }
end
