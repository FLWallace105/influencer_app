class AddPrimaryKeyToShopifyCacheTables < ActiveRecord::Migration[5.2]
  def up
  	remove_column :collects, :id
  	remove_column :custom_collections, :id
   	remove_column :product_variants, :id
  	remove_column :products, :id

  	add_column :collects, :id, :primary_key
  	add_column :custom_collections, :id, :primary_key
  	add_column :product_variants, :id, :primary_key
  	add_column :products, :id, :primary_key
  end

  def down
  	remove_column :collects, :id
  	remove_column :custom_collections, :id
   	remove_column :product_variants, :id
  	remove_column :products, :id

  	add_column :collects, :id, :primary_key
  	add_column :custom_collections, :id, :primary_key
  	add_column :product_variants, :id, :primary_key
  	add_column :products, :id, :primary_key
  end
end
