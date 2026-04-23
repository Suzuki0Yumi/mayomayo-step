module StepsHelper
  def bubble_title(feeling)
    case feeling
    when 'strong_interest'
      'すてき！一緒に進んでみよう！'
    when 'blocked_action'
      '大丈夫、一歩見つけたよ！'
    when 'light_interest'
      '小さな一歩が一番だいじだよ'
    when 'unclear_state'
      'モヤモヤするよね、ここから始めてみよう'
    else
      '今日の一歩を見つけたよ！'
    end
  end
end
