class StepsController < ApplicationController
  def top
  end

  def create
    @goal = params[:step][:goal]
    @reason = params[:step][:reason]
    @status = params[:step][:status]

    Rails.logger.debug "Goal: #{@goal}"
    Rails.logger.debug "Reason: #{@reason}"
    Rails.logger.debug "Status: #{@status}"

    render  :result
  end
end
