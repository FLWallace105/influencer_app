class InfluencersDownloadController < ApplicationController
  # def download
#   if check_box_params
#     influencers = Influencer.where(id: check_box_params[:influencers])
#     send_data(influencers.to_csv, type: 'csv', disposition: 'attachment', filename: "product-#{Time.now.strftime('%d/%m/%Y %H:%M:%S')}.csv")
#   else
#     flash['warning'] = 'You must select at least one influencer.'
#     redirect_to influencers_path
#   end
# end

  private
  def check_box_params
    params.permit(influencers: [])
  end
end
