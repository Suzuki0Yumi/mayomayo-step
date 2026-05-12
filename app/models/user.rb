class User < ApplicationRecord
  has_many :proposals, dependent: :destroy
  has_many :user_badges, dependent: :destroy
  has_many :badges, through: :user_badges
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  DAILY_PROPOSAL_LIMIT = 10

  def today_proposals_count
    proposals.where('created_at >= ?', Time.current.beginning_of_day).count
  end

  def remaining_proposals_count
    DAILY_PROPOSAL_LIMIT - today_proposals_count
  end

  def reached_daily_limit?
    today_proposals_count >= DAILY_PROPOSAL_LIMIT
  end

end
