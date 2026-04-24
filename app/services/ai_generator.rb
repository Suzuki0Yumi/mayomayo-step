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
     result || fallback_proposal(goal: goal)
  end
      
  private

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
      
      今日やる行動を1つだけ提案してください。
      行動のみを出力してください。


     【ルール】
     - 「〜してみませんか？」という提案形式
     - 100文字以内
     - 「対象 + 数量 + 動作」で具体化する
     - 迷いなく即実行できる内容にする
     - 必要なら検索ワードと参照範囲を指定する
     - 手を動かす行動に限定する（視聴・受講はNG）
     - ユーザーが自分の手や頭を使う行動に限定する
     - 時間に合った現実的な提案をする
     - 誰でもすぐ実行できるレベルにする
     - ユーザーが考えなくていいレベルまで分解すること
     - 「何をするか」が一意に決まる形にすること 
     - 特定の環境（自宅に〇〇がある前提など）に依存しない行動にする
     - 同じ種類の行動（例：書く）に偏らないようにする

     【NG例】
     - 抽象的（例：勉強する・運動する）
     - 動画を見る・講座を受ける
     - 曖昧な表現（少し・軽く）

     【検索系の行動を提案する場合】
     - 検索ワードを具体的に指定する（「」で囲む）
     - 検索後に何をするか明確にする
      例：「見出しだけ読む」「画像を1つ保存する」「最初の段落だけメモする」
     - 「YouTube」「Google」だけで終わらせない
 
     【具体例】
      - 栄養について勉強したい → 「今日食べたものを3つ書いて、それぞれに含まれる栄養素を1つ考えてみませんか？」
      - 栄養について勉強したい →「『五大栄養素とは』と検索して、出てきた説明の最初の1段落だけ読んでみませんか？」
      - 植物について詳しくなりたい → 「自宅にある植物の名前を3つ調べて、それぞれの育て方をメモしてみませんか？」
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
      あなたは、ユーザーのやりたいことを達成するための具体的な行動を提案する優秀なアシスタントです。
      余計な説明や励ましはせず、シンプルに行動のみを提示してください。
      ユーザーの情報をもとに、今日できる具体的な行動を一つだけ提案してください。
    SYSTEM
  end

  def fallback_proposal(goal:)
    "『#{goal}』について、まずは関連する情報を1つだけ調べて、気になったポイントを1つメモしてみませんか？"
  end
end
