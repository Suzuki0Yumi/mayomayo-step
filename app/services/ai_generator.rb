class AiGenerator
  def initialize
     @client = OpenAI::Client.new
  end

  def generate(goal:, feeling:, time_available:, is_retry: false, previous_proposal: nil)
     prompt = build_prompt(
       goal: goal, 
       feeling: feeling, 
       time_available: time_available, 
       is_retry: is_retry,
       previous_proposal: previous_proposal 
     )
     result = call_api(prompt)

    if result
      parse_result(result)
    else
      fallback_proposal(goal: goal)
    end
  end


  private
  
  def parse_result(text)
    lines = text.split("\n").map(&:strip).reject(&:empty?)

    parsed = {
      empathy: nil,
      action: nil,
      reason: nil,
      suggestion: text
    }

    lines.each do |line|
      case line
      when /^共感[：:]\s*(.+)$/
        parsed[:empathy] = $1.strip
      when /^提案[：:]\s*(.+)$/
        parsed[:action] = $1.strip
      when /^理由[：:]\s*(.+)$/
        parsed[:reason] = $1.strip
      end
    end

    parsed
  end

  def build_prompt(goal:, feeling:, time_available:, is_retry:, previous_proposal:)
    feeling_text = feeling
    time_available = '30min' if time_available.blank?
    time_text = time_available

    feeling_guidance = case feeling
                   when 'blocked_action'
                     '行動したい気持ちはあるので、背中を押すような提案をしてください'
                   when 'unclear_state'
                     'モヤモヤしているので、とにかく手を動かせる提案をしてください'
                   when 'light_interest'
                     'まだ興味段階なので、負担ゼロの提案をしてください'
                   when 'strong_interest'
                     'かなりやる気があるので、少し踏み込んだ提案をしてください'
                   end
 
    action_depth = case time_available
                    when '5min' 
                      '超簡単な準備や情報収集（アプリをインストール、1つの記事をブックマーク）'
                    when '30min'
                      '実際に手を動かす行動（やってみる、簡単な練習をする）'
                    when '60min_plus'
                      'じっくり取り組む行動（実際に作ってみる、複数の情報を比較する）'
                    end

    previous_text = if is_retry && previous_proposal.present?
                     "前回の提案: #{previous_proposal}"
                    else
                     ""
                    end

    is_retry_instruction = if is_retry
                         "前回の提案と同じ行動は絶対に提案しないこと。異なるアプローチで提案すること。"
                        else
                         ""
                        end

  <<~PROMPT
      ユーザーの情報:
      - やりたいこと・気になること: #{goal}
      - 今の気持ち: #{feeling_text}
      #{feeling_guidance}
      - 使える時間: #{time_text}
      - 行動レベル: #{action_depth}
       #{is_retry_instruction}
       #{previous_text}
      
   # あなたの役割
  「やりたいけど動けない人」に、今日1つだけ手を動かせるきっかけを届けること。
   選択肢を出さず、1つに絞る。

   # 出力形式（この3行のみ）
  共感：[今の気持ちを言語化した一言・30文字以内・「〜な状態ですね」で終わる]
  提案：[今日できる具体的な行動1つ・〜してみよう！形式・100文字以内]
  理由：[なぜ今それをやるのか・30文字以内]

  # 共感文のルール
  - 気持ちと目標を組み合わせて言語化
  - 「わかります」などの励まし禁止

  # 提案のルール
  - 手を動かす行動のみ（視聴NG）
  - 「対象＋数量＋動作」で具体化
  - 1アクションのみ（複数ステップ禁止）
  - 30秒以内に開始できる内容
  - 5秒でイメージできる具体性
  - 曖昧表現禁止（少し・軽く等）
  - 気持ちに合った負荷にする
   - #{time_text}で終わる現実的な内容
  - 環境依存しない

  # 検索系ルール
  - 「検索ワード」を「」で明示
  - 検索後の行動まで書く

PROMPT
  end

  def call_api(prompt)
    response = @client.chat(
       parameters: {
         model: "gpt-4o-mini",
         messages: [
           { role: "system", content: system_prompt },
           { role: "user", content: prompt}
         ],
         temperature:0.5
        }
      )
        response.dig("choices", 0, "message", "content")
  
    rescue StandardError => e
        Rails.logger.error("OpenAI API error: #{e.full_message}")
        nil
    end
  
  def system_prompt
    <<~SYSTEM
      あなたは、ユーザーの挑戦したいことを達成するための具体的かつユニークな行動を提案する優秀なアシスタントです。
      余計な説明や励ましはせず、シンプルに行動のみを提示してください。
      ユーザーの情報をもとに、今日できる具体的な行動を一つだけ提案してください。
    SYSTEM
  end

  def fallback_proposal(goal:)
    action_text = "『#{goal}』について、まずは関連する情報を1つだけ調べて、気になったポイントを1つメモしてみよう！"

    {
      empathy: "新しいことに興味を持っている状態ですね",
      action: action_text,
      reason: "小さな一歩が行動のきっかけになるから",
      suggestion: "共感：新しいことに興味を持っている状態ですね\n提案：#{action_text}\n理由：小さな一歩が行動のきっかけになるから"
    }
  end
end
