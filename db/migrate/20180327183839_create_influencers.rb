class CreateInfluencers < ActiveRecord::Migration[5.1]
  def change
    create_table :influencers do |t|
      t.string :first_name
      t.string :last_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.citext :email
      t.string :phone
      t.string :bra_size
      t.string :top_size
      t.string :bottom_size
      t.string :sports_jacket_size
      t.boolean :three_item
      t.string :shipping_method_requested
      t.bigint :collection_id
      t.index :updated_at
      
      t.timestamps
    end
  end
end
