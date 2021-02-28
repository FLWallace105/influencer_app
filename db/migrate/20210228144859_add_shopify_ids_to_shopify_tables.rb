class AddShopifyIdsToShopifyTables < ActiveRecord::Migration[5.2]
  def up
  	add_column :collects, :collect_id, :bigint
  	add_column :custom_collections, :collection_id, :bigint
  	add_column :product_variants, :variant_id, :bigint
  	add_column :products, :product_id, :bigint
  end

  def down
  	remove_column :collects, :collect_id
  	remove_column :custom_collections, :collection_id
   	remove_column :product_variants, :variant_id
  	remove_column :products, :product_id
  end
end
