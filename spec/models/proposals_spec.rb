require 'rails_helper'

RSpec.describe Proposal, type: :model do
  describe 'バリデーション' do
    it 'すべての必須項目が存在する場合、有効である' do
      proposal = build(:proposal)
      expect(proposal).to be_valid
    end

    it 'goalが空である場合無効である' do
      proposal = build(:proposal, goal: '')
      expect(proposal).to be_invalid
      expect(proposal.errors[:goal]).to include("を入力してください")
    end

    it 'goalが500字を超える場合、無効である' do
      proposal = build(:proposal, goal: 'a' * 501)
      expect(proposal).to be_invalid
      expect(proposal.errors[:goal]).to include("は500文字以内で入力してください")
    end

    it 'goalが500字以内の場合、有効である' do
      proposal = build(:proposal, goal: 'a' * 500)
      expect(proposal).to be_valid
    end

    it 'feelingが空である場合、無効である' do
      proposal = build(:proposal, feeling: nil)
      expect(proposal).to be_invalid
      expect(proposal.errors[:feeling]).to include("を入力してください")
    end

    it 'suggestionが空である場合、無効である' do
      proposal = build(:proposal, suggestion: '')
      expect(proposal).to be_invalid
      expect(proposal.errors[:suggestion]).to include("を入力してください")
    end

    it 'reasonが空である場合、無効である' do
      proposal = build(:proposal, reason: '')
      expect(proposal).to be_invalid
      expect(proposal.errors[:reason]).to include("を入力してください")
    end

    it 'actionが空である場合、無効である' do
      proposal = build(:proposal, action: '')
      expect(proposal).to be_invalid
      expect(proposal.errors[:action]).to include("を入力してください")
    end
  end

  describe 'アソシエーション' do
    it 'userに属している' do
      proposal = build(:proposal)
      expect(proposal.user).to be_present
    end

    it 'userが削除されたらproposalも削除される' do
      user = create(:user)
      proposal = create(:proposal, user: user)

      expect{ user.destroy }.to change { Proposal.count }.by(-1)
    end

    it 'userがない場合無効である' do
      proposal = build(:proposal, user: nil)
      expect(proposal).to be_invalid
    end
  end

  describe 'enum' do
    context 'status' do
      it 'acceptedが設定できる' do
        proposal = build(:proposal, status: :accepted)
        expect(proposal.status).to eq('accepted')
      end

      it 'completedが設定できる' do
        proposal = build(:proposal, status: :completed)
        expect(proposal.status).to eq('completed')
      end
    end

    context 'feeling' do
      it 'light_interestが設定できる' do
        proposal = build(:proposal, feeling: :light_interest)
        expect(proposal.feeling).to eq('light_interest')
      end

      it 'strong_interestが設定できる' do
        proposal = build(:proposal, feeling: :strong_interest)
        expect(proposal.feeling).to eq('strong_interest')
      end

      it 'blocked_actionが設定できる' do
        proposal = build(:proposal, feeling: :blocked_action)
        expect(proposal.feeling).to eq('blocked_action')
      end

      it 'unclear_statuが設定できる' do
        proposal = build(:proposal, feeling: :unclear_state)
        expect(proposal.feeling).to eq('unclear_state')
      end
    end

    context 'time_available' do
      it 'five_minが設定できる' do
        proposal = build(:proposal, time_available: :five_min)
        expect(proposal.time_available).to eq('five_min')
      end

       it 'thirty_minが設定できる' do
        proposal = build(:proposal, time_available: :thirty_min)
        expect(proposal.time_available).to eq('thirty_min')
      end

       it 'sixty_min_plusが設定できる' do
        proposal = build(:proposal, time_available: :sixty_min_plus)
        expect(proposal.time_available).to eq('sixty_min_plus')
      end
    end
  end

  describe 'scope' do
    describe 'recent' do
      it '作成日時の降順で取得できる' do
        proposal1 = create(:proposal, :created_last_week)
        proposal2 = create(:proposal, :created_yesterday)
        proposal3 = create(:proposal, :created_today)

        result = Proposal.recent
        expect(result.first).to eq(proposal3)
        expect(result.second).to eq(proposal2)
        expect(result.third).to eq(proposal1)
      end
    end
  end
end
