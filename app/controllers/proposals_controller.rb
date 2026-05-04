class ProposalsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_proposal, only: [:pending, :accepted, :completed, :skipped]

  def index 
     @status_filter = params[:status] || 'accepted'
     @proposals = case @status_filter
                  when 'accepted'
                    current_user.proposals.accepted
                  when 'completed'
                    current_user.proposals.completed
                  when 'skipped'
                    current_user.proposals.skipped
                  else
                    current_user.proposals.pending
                  end.order(created_at: :desc)
   end

    def pending
      @proposal.pending!
      redirect_to proposals_path, notice: '提案に戻しました'
    rescue ActiveRecord::RecordInvalid
      redirect_to proposals_path, alert: '更新に失敗しました'
    end

    def accepted
      @proposal.accepted!
      redirect_to proposals_path, notice: '一覧に追加しました！一緒に頑張ろう🌱'
    rescue ActiveRecord::RecordInvalid
      redirect_to proposals_path, alert: '追加に失敗しました'
    end

    def completed
      @proposal.completed!
      redirect_to proposals_path, notice: 'やったね！🎉'
    rescue ActiveRecord::RecordInvalid
      redirect_to proposals_path, alert: '更新に失敗しました'
    end

    def skipped
      @proposal.skipped!
      redirect_to proposals_path, notice: 'スキップしました'
    rescue ActiveRecord::RecordInvalid
      redirect_to proposals_path, alert: '更新に失敗しました'
    end

    private

    def set_proposal
      @proposal = current_user.proposals.find(params[:id])
    end
end
