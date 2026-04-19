class AiGenerator
  def initialize
     @client = OpenAI::Client.new
  end

  def generate(goal:, feeling:, time_available:, blocker:)
     prompt = build_prompt(
       goal: goal, 
       feeling: feeling, 
       time_available: time_available, 
       blocker: blocker  
     )
     call_api(prompt)
  end
      
  private

  def build_prompt(goal:, feeling:, time_available:, blocker:)
    <<~PROMPT
      ユーザーの情報:
      - やりたいこと・気になること: #{goal}
      - 今の気持ち: #{feeling}
      - 使える時間: #{time_available}
      - 邪魔しているもの: #{blocker.presence || "特になし"}

      上記をもとに、今日できる小さな一歩を一つだけ提案してください。
      優しく、具体的に、100～150文字程度でお願いします。
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
         temperature:0.7
        }
      )
        response.dig("choices", 0, "message", "content")
  
    rescue StandardError => e
        Rails.logger.error("OpenAI API error: #{e.full_message}")
        nil
    end
  
  def system_prompt
    "あなたは「まよまよ」という優しいコーチです。"\
    "行動できずに迷っている人に寄り添い、今日できる小さな一歩を提案します。"\
    "押し付けず、温かく、具体的な言葉で話しかけてください。"
  end
end
