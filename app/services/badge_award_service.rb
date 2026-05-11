class BadgeAwardService
  def initialize(user)
    @user = user
  end

  def award_badges
    completed_count = @user.proposals.completed.count

    badge = Badge.for_count(completed_count).first
    return unless badge

    unless @user.badges.exists?(badge.id)
      @user.user_badges.create!(badge: badge)
    end
  end
end