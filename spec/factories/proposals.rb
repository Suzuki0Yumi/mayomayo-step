FactoryBot.define do
  factory :proposal do
    association :user

    goal { "プログラミングの基礎を学ぶ" }
    feeling { :light_interest }
    suggestion { "毎日30分コードを書く習慣をつける" }
    reason { "継続的な学習の上達の鍵だから" }
    action { "朝の時間を活用して学習する" }
    status { :accepted }
    time_available { :thirty_min}

    trait :created_today do
      created_at { Time.current }
    end

    trait :created_yesterday do
      created_at { 1.day.ago }
    end

    trait :created_last_week do
      created_at { 1.week.ago }
    end

    trait :completed do
      status { :completed }
    end

    trait :light_interest do
      feeling { :light_interest }
    end

    trait :strong_interest do
      feeling { :strong_interest }
    end

    trait :blocked_action do
      feeling { :blocked_action }
    end

    trait :unclear_status do
      feeling { :unclear_state }
    end

    trait :five_min do
      time_available { :five_min }
    end
    
    trait :sixty_min_plus do
      time_available { :sixty_min_plus}
    end
  end
end