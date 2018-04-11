class ShopifyCachesController < ApplicationController
  def refresh_all
    ShopifyCachePullAllJob.perform_later
    flash[:success] = 'Refreshing entire Shopify Cache. Please wait a couple mintues...'
    redirect_to root_path
  end
end
