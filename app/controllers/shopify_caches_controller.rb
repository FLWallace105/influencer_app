class ShopifyCachesController < ApplicationController
  def refresh_all
    ShopifyCachePullAllJob.perform_later
    flash[:success] = 'Refreshing entire Shopify Cache'
    redirect_to :root_path
  end
end
