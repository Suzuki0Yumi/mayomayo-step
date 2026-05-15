require 'rails_helper'

RSpec.describe Badge, type: :model do
  describe 'バリデーション' do
    it '名前が空である場合、無効である' do
      badge = build(:badge, name: '')
      expect(badge).to be_invalid
      expect(badge.errors[:name]).to include("を入力してください")
    end

    it '名前が存在する場合、有効である' do
      badge = build(:badge)
      expect(badge).to be_valid
    end

    it 'バッジの種類(badge_type)が未設定なら無効である' do
      badge = build(:badge, badge_type: nil)
      expect(badge).to be_invalid
      expect(badge.errors[:badge_type]).to include("を入力してください")
    end
  end

  describe 'アソシエーション' do
    it 'user_badgesを複数持つことができる' do
      badge = create(:badge)
      user1 = create(:user)
      user2 = create(:user)

      badge.user_badges.create(user: user1)
      badge.user_badges.create(user: user2)

      expect(badge.user_badges.count).to eq(2)
    end

    it 'badgeが削除されたらuser_badgesも削除される' do
      badge = create(:badge)
      user = create(:user)
      user_badge = badge.user_badges.create(user: user)

      expect{ badge.destroy }.to change { UserBadge.count }.by(-1)
    end

    it 'usersを複数持つことができる' do
      badge = create(:badge)
      user1 = create(:user)
      user2 = create(:user)

      badge.user_badges.create(user:user1)
      badge.user_badges.create(user:user2)

      expect(badge.users.count).to eq(2)
    end
  end

  describe '#badge_type_label' do
    context '提案達成度によってバッジを付与する' do
      it 'badge_type_labelが日本語のラベルを返すこと' do
        badge = build(:badge, badge_type: :first_proposal)
        expect(badge.badge_type_label).to eq('最初の一歩')
      end
    end
  end

  describe 'for_count scope' do
    before do
      create(:badge, badge_type: :first_proposal)
      create(:badge, badge_type: :three_proposals)
      create(:badge, badge_type: :ten_proposals)
      create(:badge, badge_type: :thirty_proposals)
    end

    it '1回達成はfirst_proposalのみ返すこと' do
      result = Badge.for_count(1)
      expect(result.map(&:badge_type)).to eq(['first_proposal'])
    end
  
    it '3回達成はthree_proposalsのみ返すこと' do
      result = Badge.for_count(3)
      expect(result.map(&:badge_type)).to eq(['three_proposals'])
    end

    it '10回達成はten_proposalsのみ返すこと' do
      result = Badge.for_count(10)
      expect(result.map(&:badge_type)).to eq(['ten_proposals'])
    end

    it '30回達成はthirty_proposalsのみ返すこと' do
      result = Badge.for_count(30)
      expect(result.map(&:badge_type)).to eq(['thirty_proposals'])
    end

    it '該当するバッジがない場合は配列を返すこと' do
      result = Badge.for_count(15)
      expect(result).to be_empty
    end

  end
end
