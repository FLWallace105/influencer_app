class AddIndexesToInfluencerTracking < ActiveRecord::Migration[5.1]
  def change
    add_index :influencer_tracking, :order_name
    add_index :influencer_orders, :name
  end
end
