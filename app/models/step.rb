class Step
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :goal, :string
  attribute :feeling, :string
  attribute :time_available, :string

  validates :goal, presence: { message: 'を入力してください' }, 
                   length: { maximum: 500, message: '500文字以内で入力してください' }
  validates :feeling, presence: { message: 'を選択してください' },
                      inclusion: { in: %w[light_interest strong_interest blocked_action unclear_state], message: '正しい気持ちを選択してください',  allow_blank: true}
  validates :time_available, inclusion: { in: %w[5min 30min 60min_plus], allow_blank: true, message: '正しい大きさを選択してください'}

  FEELINGS = {
    'light_interest' => '気になっているだけ',
    'strong_interest' => 'ちょっとやりたい',
    'blocked_action' => '動きたいけど重い',
    'unclear_state' => 'なんとなくモヤモヤ'
  }.freeze

  TIME_AVAILABLE_OPTIONS = {
    '5min' => 'めちゃ軽く',
    '30min' => 'ふつう',
    '60min_plus' => '少しだけ頑張る'
  }.freeze


end