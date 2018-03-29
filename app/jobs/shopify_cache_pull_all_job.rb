class ShopifyCachePullAllJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ShopifyCache.pull_all
  end
end
