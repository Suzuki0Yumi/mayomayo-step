class BadgesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @all_badges = Badge.all
    @earned_badge_ids = current_user.badges.pluck(:id)
  end
end
