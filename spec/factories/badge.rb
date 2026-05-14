FactoryBot.define do
  factory :badge do
    name { "テストバッジ" }
    badge_type { :first_proposal }
    image_path { "test.png" }
  end
end