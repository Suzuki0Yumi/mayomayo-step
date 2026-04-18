class Step
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :goal, :string
  attribute :feeling, :string
  attribute :time_available, :string
  attribute :blocker, :string

  validates :goal, presence: { message: 'を入力してください' }, 
                   length: { maximum: 500, message: '500文字以内で入力してください' }
  validates :feeling, presence: { message: 'を選択してください' },
                      inclusion: { in: %w[light_interest strong_interest blocked_action unclear_state], message: '正しい気持ちを選択してください',  allow_blank: true}
  validates :time_available, presence: { message: 'を選択してください' },
                             inclusion: { in: %w[5min 30min 60min_plus], allow_blank: true}               
  validates :blocker, inclusion: { in: %w[tired unclear_how lazy_friction low_energy], allow_blank: true, message: '正しい項目を選択してください' }

  FEELINGS = {
    'light_interest' => 'ちょっと変わりたい',
    'strong_interest' => '気になっているだけ',
    'blocked_action' => '動きたいけど重い',
    'unclear_state' => 'なんとなくモヤモヤ'
  }.freeze

  TIME_AVAILABLE_OPTIONS = {
    '5min' => '5分',
    '30min' => '30分',
    '60min_plus' => '1時間以上'
  }.freeze

  BLOCKERS = {
    'tired' => '疲れている',
    'unclear_how' => 'やり方がわからない',
    'lazy_friction' => 'めんどくさい',
    'low_energy' => 'やる気が出ない'
    }.freeze

end