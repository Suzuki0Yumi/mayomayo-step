module StepsHelper
  
  def feeling_message(feeling_value)
    case feeling_value
    when 'light_interest'
      '「ちょっと変わりたい」という気持ち、素敵ですね!'
    when 'strong_interest'
      '気になっているということは、心のどこかで興味があるんですね。'
    when 'blocked_action'
      '動きたい気持ちはあるのに重く感じる...その気持ち、よくわかります。'
    when 'unclear_state'
      'モヤモヤしている時こそ、小さな行動が助けになりますよ。'
    else
      ''
    end
  end

  def time_message(time_available)
    case time_available
    when '5min' then '5分'
    when '30min' then '30分'
    when '60min_plus' then '1時間以上'
    else time_available
    end
  end

  def blocker_message(blocker_value)
    return '' if blocker_value.blank?
    
    case blocker_value
    when 'tired'
      '疲れている時は、無理しなくて大丈夫。できる範囲で。'
    when 'unclear_how'
      'やり方がわからない時は、まず情報を集めることから始めましょう。'
    when 'lazy_friction'
      'めんどくさい気持ち、わかります。だからこそ、超簡単なことから。'
    when 'low_energy'
      'やる気が出ない日もあります。そんな日は、ほんの少しだけでOK。'
    else
      ''
    end
  end

end
