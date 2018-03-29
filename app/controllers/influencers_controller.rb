class InfluencersController < ApplicationController
  def index
  end

  def new
  end

  def import
    count = Influencer.import params[:file]
    flash[:notice] = "Imported #{count} influencers"
    redirect_back(fallback_location: root_path)
  end
end
