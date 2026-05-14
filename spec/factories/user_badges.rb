FactoryBot.define do
  factory :user_badge do
    association :badge
    association :user

    trait :earned do
      achieved_at { Time.current }
    end

    trait :unearned do
      achieved_at { nil }
    end
  end
end