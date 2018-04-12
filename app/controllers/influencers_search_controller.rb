class InfluencersSearchController < ApplicationController
  def search
    @query = params[:query].presence.try(:strip) || '*'
    if @query == '*'
      @influencers = Influencer.all.page(params[:page]).per(100)
    else
      @influencers = Influencer.search_by_email_or_name(@query)
                               .order('created_at DESC').page(params[:page]).per(100)
    end
  end
end
