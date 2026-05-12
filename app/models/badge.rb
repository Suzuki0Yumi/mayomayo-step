class Badge < ApplicationRecord
  has_many :user_badges, dependent: :destroy
  has_many :users, through: :user_badges

  validates :name, presence: true
  validates :badge_type, presence: true
  
  enum badge_type: {
    first_proposal: 'first_proposal',
    three_proposals: 'three_proposals',
    ten_proposals: 'ten_proposals',
    thirty_proposals: 'thirty_proposals'
  }

  scope :for_count, ->(count){ 
    case count
    when 1  
      where(badge_type: :first_proposal)
    when 3 
      where(badge_type: :three_proposals)
    when 10  
      where(badge_type: :ten_proposals)
    when 30
      where(badge_type: :thirty_proposals)
    else
      none
    end
  }
 
  BADGE_TYPE_LABELS = {
    'first_proposal' => '最初の一歩',
    'three_proposals' => '3回の提案',
    'ten_proposals' => '10回の提案',
    'thirty_proposals' => '30回の提案'
 }.freeze

 def badge_type_label
    BADGE_TYPE_LABELS[badge_type]
  end

end

