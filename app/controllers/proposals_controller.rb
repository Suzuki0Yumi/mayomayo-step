class ProposalsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_proposal, only: [:show, :accepted, :completed, :destroy]

  def index 
     @status_filter = params[:status] || 'accepted'
     @proposals = case @status_filter
                  when 'accepted'
                    current_user.proposals.accepted
                  when 'completed'
                    current_user.proposals.completed
                  else
                    current_user.proposals.accepted
                  end.order(created_at: :desc)
   end

    def accepted
      @proposal.accepted!
      redirect_to proposals_path, notice: '提案を「実行中」に追加しました！'
    rescue ActiveRecord::RecordInvalid
      redirect_to proposals_path, alert: '更新に失敗しました'
    end

    def completed
      @proposal.completed!
      newly_awarded_badges = BadgeAwardService.new(current_user).award_badges
      
      if newly_awarded_badges.any?
        flash[:badge_earned] = newly_awarded_badges.first
        redirect_to proposals_path, notice: "やったね！🎉「#{newly_awarded_badges.first.name}」バッジを獲得しました！"
      else
        redirect_to proposals_path, notice: 'やったね！🎉'
      end
      rescue ActiveRecord::RecordInvalid
        redirect_to proposals_path, alert: '更新に失敗しました'
    end

    def new
      @proposal = Proposal.new
    end

    def show
    end

    def destroy
     @proposal.destroy
     redirect_to proposals_path, notice: '提案を削除しました'
    end
    
    private

    def set_proposal
      @proposal = current_user.proposals.find(params[:id])
    end
end
