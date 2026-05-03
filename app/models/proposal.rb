class Proposal < ApplicationRecord
  belongs_to :user

  validates :goal, presence: true, length: { maximum: 500 }
  validates :feeling, presence: true, 
             inclusion: { in: %w[light_interest strong_interest blocked_action unclear_state] }
  validates :time_available, 
             inclusion: { in: %w[5min 30min 60min_plus], allow_blank: true }
  validates :suggestion, presence: true

  enum status: { pending: 0, accepted: 1, rejected: 2 }
  enum feeling: { 
    light_interest: 0, 
    strong_interest: 1, 
    blocked_action: 2, 
    unclear_state: 3 
  }
  enum time_available: { 
    five_min: 0, 
    thirty_min: 1, 
    sixty_min_plus: 2 
  }
  
  scope :recent, -> { order(created_at: :desc) }
end
