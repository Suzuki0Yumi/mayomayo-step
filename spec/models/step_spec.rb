require 'rails_helper'

RSpec.describe Step, type: :model do
  describe 'バリデーション' do
    context 'goal' do
      it 'goalが存在する場合、有効である' do
        step = Step.new(goal: 'プログラミングの基礎を学ぶ', feeling: 'light_interest')
        expect(step).to be_valid
      end

      it 'goalが空である場合、無効である' do
        step = Step.new(goal: '', feeling: 'light_interest')
        expect(step).to be_invalid
        expect(step.errors[:goal]).to include('を入力してください')
      end

      it 'goalが500文字を超える場合、無効である' do
        step = Step.new(goal: 'a' * 501, feeling: 'light_interest')
        expect(step).to be_invalid
        expect(step.errors[:goal]).to include('500文字以内で入力してください')
      end

      it 'goalが500文字以内の場合、有効である' do
        step = Step.new(goal: 'a' * 500, feeling: 'light_interest')
        expect(step).to be_valid
      end
    end

    context 'feeling' do
      it 'feelingが存在する場合、有効である' do
        step = Step.new(goal: 'プログラミングの基礎を学ぶ', feeling: 'light_interest')
        expect(step).to be_valid
      end

      it 'feelingが空である場合、無効である' do
        step = Step.new(goal: 'プログラミングの基礎を学ぶ', feeling: '')
        expect(step).to be_invalid
        expect(step.errors[:feeling]).to include('を選択してください')
      end

      it 'feelingが正しい値の場合、有効である' do
        %w[light_interest strong_interest blocked_action unclear_state].each do |feeling|
          step = Step.new(goal: 'プログラミングの基礎を学ぶ', feeling: feeling)
          expect(step).to be_valid
        end
      end

      it 'feelingが不正な値の場合、無効である' do
        step = Step.new(goal: 'プログラミングの基礎を学ぶ', feeling: 'invalid_feeling')
        expect(step).to be_invalid
        expect(step.errors[:feeling]).to include('正しい気持ちを選択してください')
      end
    end

    context 'time_available' do
      it 'time_availableが空でも有効である' do
        step = Step.new(goal: 'プログラミングの基礎を学ぶ', feeling: 'light_interest', time_available: '')
        expect(step).to be_valid
      end

      it 'time_availableが正しい値の場合、有効である' do
        %w[5min 30min 60min_plus].each do |time_available|
          step = Step.new(goal: 'プログラミングの基礎を学ぶ', feeling: 'light_interest', time_available: time_available)
          expect(step).to be_valid
        end
      end

      it 'time_availableが不正な値の場合、無効である' do
        step = Step.new(goal: 'プログラミングの基礎を学ぶ', feeling: 'light_interest', time_available: 'invalid_time')
        expect(step).to be_invalid
        expect(step.errors[:time_available]).to include('正しい大きさを選択してください')
      end
    end
  end

  describe '定数' do
    it 'FEELINGS が正しく定義されている' do
      expect(Step::FEELINGS).to eq({
        'light_interest' => '気になっているだけ',
        'strong_interest' => 'ちょっとやりたい',
        'blocked_action' => '動きたいけど重い',
        'unclear_state' => 'なんとなくモヤモヤ'
      })
    end

    it 'TIME_AVAILABLE_OPTIONS が正しく定義されている' do
      expect(Step::TIME_AVAILABLE_OPTIONS).to eq({
        '5min' => '軽く',
        '30min' => 'ふつう',
        '60min_plus' => '頑張りたい'
      })
    end
  end
end
