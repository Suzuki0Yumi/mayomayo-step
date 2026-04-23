class StepsController < ApplicationController
  
  def new
    @step = Step.new
  end

  def generate
    @step = Step.new(step_params)

    if @step.valid?
      is_retry = retry_params[:is_retry]
      previous = retry_params[:previous_proposal]

      ai = AiGenerator.new
      @proposal = ai.generate(
        goal: @step.goal,
        feeling: @step.feeling,
        time_available: @step.time_available,
        is_retry: is_retry,
        previous_proposal: previous
      )
      @proposal ||= build_mock_proposal
      render  :result
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
end
