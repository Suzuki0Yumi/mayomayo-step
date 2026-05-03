class StepsController < ApplicationController
  before_action :authenticate_user!

  def new
    @step = Step.new
  end

  def generate
    @step = Step.new(step_params)

    if @step.valid?
      is_retry = retry_params[:is_retry]
      previous = retry_params[:previous_proposal]

      ai = AiGenerator.new
      suggestion = ai.generate(
        goal: @step.goal,
        feeling: Step::FEELINGS[@step.feeling],
        time_available: Step::TIME_AVAILABLE_OPTIONS[@step.time_available],
        is_retry: is_retry,
        previous_proposal: previous
      )

      @proposal = current_user.proposals.build(
        goal: @step.goal,
        feeling: map_feeling(@step.feeling),
        time_available: map_time_available(@step.time_available),
        suggestion: suggestion,
        status: :pending
      )

      if @proposal.save
        render :result
      else
      flash.now[:error] = '提案の保存に失敗しました'
      render :new, status: :unprocessable_entity
      end

    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def step_params
    params.require(:step).permit(:goal, :feeling, :time_available)
  end

  def retry_params
    params.permit(:is_retry, :previous_proposal)
  end

  def map_time_available(value)
    case value
    when '5min' then :five_min
    when '30min' then :thirty_min
    when '60min_plus' then :sixty_min_plus
    else value.to_sym
    end
  end
  
  def map_feeling(value)
    case value
    when 'light_interest' then :light_interest
    when 'strong_interest' then :strong_interest
    when 'blocked_action' then :blocked_action
    when 'unclear_state' then :unclear_state
    else value.to_sym
    end
  end

end
