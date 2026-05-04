class ProposalsController < ApplicationController
    before_action :authenticate_user!

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
      @proposal = current_user.proposals.find(params[:id])
      if @proposal.update(status: :pending)
        redirect_to proposals_path, notice: '提案に戻しました'
      else
        redirect_to proposals_path, alert: '更新に失敗しました'
      end
    end

    def accepted
      @proposal = current_user.proposals.find(params[:id])
      if @proposal.update(status: :accepted)
        redirect_to proposals_path, notice: '一覧に追加しました！一緒に頑張ろう🌱'
      else
        redirect_to proposals_path, alert: '追加に失敗しました'
      end 
    end

    def completed
      @proposal = current_user.proposals.find(params[:id])
      if @proposal.update(status: :completed)
        redirect_to proposals_path, notice: 'やったね！🎉'
      else
        redirect_to proposals_path, alert: '更新に失敗しました'
      end
    end

    def skipped
      @proposal = current_user.proposals.find(params[:id])
      if @proposal.update(status: :skipped)
        redirect_to proposals_path, notice: 'スキップしました'
      else
        redirect_to proposals_path, alert: '更新に失敗しました'
      end
    end
end
