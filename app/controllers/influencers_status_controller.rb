class InfluencersStatusController < ApplicationController
  def mark_active
    count = 0
    influencers = Influencer.where(id: check_box_params[:influencers])
    influencers.each do |influencer|
      influencer.update(active: true) && count += 1
    end

    flash[:success] = "#{count} #{'influencer'.pluralize(count)} marked active."
    redirect_to influencers_path
  end

  def mark_inactive
    count = 0
    influencers = Influencer.where(id: check_box_params[:influencers])
    influencers.each do |influencer|
      influencer.update(active: false) && count += 1
    end

    flash[:success] = "#{count} #{'influencer'.pluralize(count)} marked inactive."
    redirect_to influencers_path
  end

  private

  def check_box_params
    params.permit(influencers: [])
  end
end
