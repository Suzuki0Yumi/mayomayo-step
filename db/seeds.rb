# バッジの初期データを作成
puts 'バッジデータを作成中...'

Badge.find_or_create_by!(name: '最初の一歩') do |badge|
  badge.badge_type = :first_proposal
  badge.description = '初めての提案達成おめでとう！'
  badge.image_path = 'badges/first_proposals.png'
end

Badge.find_or_create_by!(name: '3回の提案') do |badge|
  badge.badge_type = :three_proposals
  badge.description = '3回の提案を達成おめでとう！'
  badge.image_path = 'badges/three_proposals.png'
end

Badge.find_or_create_by!(name: '10回の提案') do |badge|
  badge.badge_type = :ten_proposals
  badge.description = '10回の提案を達成おめでとう！'
  badge.image_path = 'badges/ten_proposals.png'
end

Badge.find_or_create_by!(name: '30回の提案') do |badge|
  badge.badge_type = :thirty_proposals
  badge.description = '30回の提案を達成おめでとう！'
  badge.image_path = 'badges/thirty_proposals.png'
end

puts "#{Badge.count}件のバッジを作成しました"