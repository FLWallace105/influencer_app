class Collect < ApplicationRecord
  belongs_to :product, primary_key: :product_id, foreign_key: :product_id
  belongs_to :collection, primary_key: :collection_id, foreign_key: :collection_id, class_name: 'CustomCollection'
end
