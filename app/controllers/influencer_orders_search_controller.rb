class InfluencerOrdersSearchController < ApplicationController
  def search
    @query = params[:query].presence.try(:strip) || '*'
    if @query == '*'
      ids = InfluencerOrder.pluck(:name, :id).uniq(&:first).map(&:last)
    else
      order_groups = InfluencerOrder.search_by_name_or_last_name(@query)
      ids = order_groups.pluck(:name, :id).uniq(&:first).map(&:last)
    end

    @influencer_orders = InfluencerOrder.where(id: ids).includes(:tracking).page(params[:page]).per(100)
  end
end
