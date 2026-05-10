class Proposal < ApplicationRecord
  belongs_to :user

  validates :goal, presence: true, length: { maximum: 500 }
  validates :feeling, presence: true
  validates :suggestion, presence: true
  validates :reason, presence: true
  validates :action, presence: true

  enum status: { accepted: 0, completed: 1 }
  
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
