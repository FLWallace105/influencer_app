class AddActiveToInfluencers < ActiveRecord::Migration[5.1]
  def change
    add_column :influencers, :active, :boolean, default: :true 
  end
end
