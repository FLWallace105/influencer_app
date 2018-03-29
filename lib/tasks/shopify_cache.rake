namespace :shopify_cache do
  desc 'refresh all caches from shopify'
  task pull_all: :environment do
    ShopifyCachePullAllJob.perform_later
  end
end
