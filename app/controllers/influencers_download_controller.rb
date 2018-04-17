class InfluencersDownloadController < ApplicationController
  def download_selected
    influencers = Influencer.where(id: check_box_params[:influencers])
    send_data(influencers.to_csv, type: 'csv', disposition: 'attachment', filename: "selected_influencers-#{Time.now.strftime('%d/%m/%Y %H:%M:%S')}.csv") && return
  end

  def download_all
    influencers = Influencer.all
    send_data(influencers.to_csv, type: 'csv', disposition: 'attachment', filename: "all_influencers-#{Time.now.strftime('%d/%m/%Y %H:%M:%S')}.csv")
  end

  private
  def check_box_params
    params.permit(influencers: [])
  end
end
