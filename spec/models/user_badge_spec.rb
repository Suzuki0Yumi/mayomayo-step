require 'rails_helper'

RSpec.describe UserBadge, type: :model do
  describe 'バリデーション' do
    it 'userがない場合、無効である' do
      user_badge = build(:user_badge, user: nil)
      expect(user_badge).to be_invalid
      expect(user_badge.errors[:user]).to include('を入力してください')
    end

    it 'badgeがない場合、無効である' do
      user_badge = build(:user_badge, badge: nil)
      expect(user_badge).to be_invalid
      expect(user_badge.errors[:badge]).to include('を入力してください')
    end
  end

  describe 'アソシエーション' do
    it 'userに属している' do
      user_badge = create(:user_badge)
      expect(user_badge.user).to be_present
    end

    it 'badgeに属している' do
      user_badge = create(:user_badge)
      expect(user_badge.badge).to be_present
    end
  end
end