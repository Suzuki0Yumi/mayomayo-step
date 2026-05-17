require 'rails_helper'

RSpec.describe BadgeAwardService, type: :service do
  let(:user) { create(:user) }
  let(:service) { described_class.new(user) }

  describe '#award_badges' do
    context '完了した提案が0件の場合' do
      it 'バッジが付与されない' do
        expect(service.award_badges).to be_empty
      end
    end

    context '完了した提案が1件の場合' do
      let!(:badge){ create(:badge, badge_type: :first_proposal )}
      
      before do
        create(:proposal, user:user, status: :completed)
      end

      it 'バッジが付与される' do
        expect{ service.award_badges }.to change(user.user_badges, :count).by(1)
      end

      it '獲得したバッジ情報が取得できる'do
        awarded_badges = service.award_badges
        expect(awarded_badges).to include(badge)
      end
    end

    context 'すでにバッジを持っている場合' do
      let!(:badge){ create(:badge, badge_type: :first_proposal)}

      before do
        create(:proposal, user: user, status: :completed)
        user.user_badges.create!(badge:badge)
      end

      it 'バッジが重複して付与されない' do
        expect{ service.award_badges }.not_to change(user.user_badges, :count)
      end

      it '空の配列が返される' do
        expect(service.award_badges).to be_empty
      end
    end

    context '完了した提案が複数件の場合' do
      let!(:badge_1){ create(:badge, badge_type: :first_proposal)}
      let!(:badge_3){ create(:badge, badge_type: :three_proposals)}

      before do
        create_list(:proposal, 3, user: user, status: :completed)
      end

      it '条件に合うバッジが付与される' do
        awarded_badges = service.award_badges
        expect(awarded_badges).to include(badge_3)
      end

      it 'first_proposalのバッジは付与されない' do
        awarded_badges = service.award_badges
        expect(awarded_badges).not_to include(badge_1)
      end
    end

    context 'バッジが存在しない場合' do
      before do
        create(:proposal, user: user, status: :completed)
      end

      it 'バッジが付与されない' do
        expect(service.award_badges).to be_empty
      end
    end
  end
end