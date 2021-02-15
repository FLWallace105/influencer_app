ShopifyAPI::Base.site = "https://#{Rails.application.credentials[:shopify][:api_key]}:#{Rails.application.credentials[:shopify][:password]}@#{Rails.application.credentials[:shopify][:shop_name]}.myshopify.com/admin"
ShopifyAPI::Base.api_version = '2020-04'
ShopifyAPI::Base.timeout = 180
