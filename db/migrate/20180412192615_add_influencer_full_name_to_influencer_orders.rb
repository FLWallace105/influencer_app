class AddInfluencerFullNameToInfluencerOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :influencer_orders, :influencer_full_name, :string
  end
end
