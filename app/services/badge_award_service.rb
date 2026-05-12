class BadgeAwardService
  def initialize(user)
    @user = user
  end

  def award_badges
    newly_awarded_badges = []
    completed_count = @user.proposals.completed.count

    badge = Badge.for_count(completed_count).first
    return newly_awarded_badges unless badge

    unless @user.badges.exists?(badge.id)
      @user.user_badges.create!(badge: badge)
      newly_awarded_badges << badge
    end

    newly_awarded_badges
  end
end