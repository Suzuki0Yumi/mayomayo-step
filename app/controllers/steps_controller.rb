class StepsController < ApplicationController
  include StepsHelper
  
  def new
  end

  def generate
    @goal = params[:step][:goal]
    @feeling = params[:step][:feeling]
    @time_available = params[:step][:time_available]
    @blocker = params[:step][:blocker]

    Rails.logger.debug "Goal: #{@goal}"
    Rails.logger.debug "Feeling: #{@feeling}"
    Rails.logger.debug "Time Available: #{@time_available}"
    Rails.logger.debug "Blocker: #{@blocker}"

    # AI統合前は固定の提案文を生成
    @proposal = build_mock_proposal
    render  :result
  end

# 開発用: 結果画面を直接確認するアクション
  def result
    # テスト用のダミーデータ
    @goal = "朝のランニングを始める"
    @feeling = "light_interest"
    @time_available = "30min"
    @blocker = "lazy_friction"
    @proposal = build_mock_proposal
  end

  private

  def build_mock_proposal
    <<~TEXT
      🌱 今日の一歩

      「#{@goal}」に興味があるんですね!
      
      #{feeling_message(@feeling)}
      
      使える時間は#{time_message(@time_available)}ですね。
      それなら、こんな小さな一歩はどうでしょう？

      ・スマホのメモに「やってみたいこと」を1つ書く

      #{blocker_message(@blocker)}

      小さなことでも大丈夫。一緒に進めていきましょう 🌱
    TEXT
  end
end
