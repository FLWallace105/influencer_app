class DropShopifyOrders < ActiveRecord::Migration[5.1]
  def change
    drop_table :shopify_orders
  end
end
