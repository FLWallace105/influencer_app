class AddIndexesToInfluencerTrackings < ActiveRecord::Migration[5.1]
  def change
    add_index :influencer_trackings, :order_name
    add_index :influencer_orders, :name
  end
end
