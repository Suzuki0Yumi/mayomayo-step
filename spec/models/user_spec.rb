require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    context 'メールアドレス' do
      it '空の場合は無効であること' do
        user = build(:user, email:nil)
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("を入力してください")
      end
     
      it '重複してる場合は無効であること' do
        create(:user, email: 'test@example.com')
        user = build(:user, email: 'test@example.com')
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('はすでに存在します')
      end

      it '正しい形式の場合は有効であること' do
        user = build(:user, email: 'valid@example.com')
        expect(user).to be_valid
      end

      it '不正な形式の場合は無効であること' do
        user = build(:user, email: 'invalid_email')
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("は不正な値です")
      end
    end

    context 'パスワード' do
      it '空の場合は無効であること' do
        user = build(:user, password:nil)
        expect(user).to be_invalid
        expect(user.errors[:password]).to include("を入力してください")
      end

      it '6文字未満の場合は無効であること' do
        user = build(:user, password: '12345')
        expect(user).to be_invalid
        expect(user.errors[:password]).to include("は6文字以上で入力してください")
      end

      it '6文字以上の場合は有効であること' do
        user = build(:user, password: '123456', password_confirmation: '123456')
        expect(user).to be_valid
      end

      it 'パスワードと確認用パスワードが一致しない場合は無効であること' do
        user = build(:user, password: '123456', password_confirmation: '654321')
        expect(user).to be_invalid
        expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end
    end  
  end

  describe 'アソシエーション' do
    it 'proposalsを複数持つことができる' do
      association = User.reflect_on_association(:proposals)
      expect(association.macro).to eq :has_many
    end

    it 'user_badgeを複数持つことができる' do
      association = User.reflect_on_association(:user_badges)
      expect(association.macro).to eq :has_many
    end

    it 'badgesをuser_badgesを通じて持つことができる' do
      association = User.reflect_on_association(:badges)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :user_badges
    end

    it 'ユーザーが削除されたらproposalsも削除される' do
      user = create(:user)
      create(:proposal, user:user)

      expect{ user.destroy }.to change{ Proposal.count }.by(-1)
    end

    it 'ユーザーが削除されたらuser_badgesも削除される' do
      user = create(:user)
      badge = create(:badge)
      create(:user_badge, user: user, badge: badge)

      expect{ user.destroy }.to change { UserBadge.count }.by(-1)
    end
  end

  describe '#today_proposals_count' do
    it '今日の提案数を返す' do
      user = create(:user)
      create_list(:proposal, 3, :created_today, user: user)

      expect(user.today_proposals_count).to eq(3)
    end

    it '昨日の提案は含まれないこと' do
      user = create(:user)
      create_list(:proposal, 2, :created_today, user: user)
      create_list(:proposal, 3, :created_yesterday, user: user)

      expect(user.today_proposals_count).to eq(2)
    end

    it '他のユーザーの提案は含まれないこと' do
      user1 = create(:user)
      user2 = create(:user)
      create_list(:proposal, 3, :created_today, user: user1)
      create_list(:proposal, 5, :created_today, user: user2)

      expect(user1.today_proposals_count).to eq(3)
    end
  end

  describe '#remaining_proposals_count' do
    context '1日あたりの提案制限（10件）' do
      it '残り提案可能数を返すこと' do
        user = create(:user)
        create_list(:proposal, 3, :created_today, user: user)

        expect(user.remaining_proposals_count).to eq(7)
      end

      it '上限に達したら0を返すこと' do
        user = create(:user)
        create_list(:proposal, 10, :created_today, user:user)

        expect(user.remaining_proposals_count).to eq(0)
      end

      it '残り件数は0未満にならないこと' do
        user = create(:user)
        create_list(:proposal, 11, :created_today, user:user)

        expect(user.remaining_proposals_count).to eq(0)
      end
    end
  end

  describe '#reached_daily_limit?' do
    context '1日あたりの提案制限（10件）' do
      it '上限未満ならfalseを返すこと' do
        user = create(:user)
        create_list(:proposal, 9, :created_today, user: user)

        expect(user.reached_daily_limit?).to be false
      end

      it '上限に達したらtrueを返すこと' do
        user = create(:user)
        create_list(:proposal, 10, :created_today, user: user)

        expect(user.reached_daily_limit?).to be true
      end

      it '上限を超えたらtrueを返すこと' do
        user = create(:user)
        create_list(:proposal, 11, :created_today, user: user)

        expect(user.reached_daily_limit?).to be true
      end

      it '提案が0件ならfalseを返すこと' do
        user = create(:user)

        expect(user.reached_daily_limit?).to be false
      end
    end
  end
end
