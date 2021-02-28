class Product < ActiveRecord::Base
  has_many :variants, primary_key: :product_id, foreign_key: :product_id, class_name: 'ProductVariant'
  has_many :collects, primary_key: :product_id, foreign_key: :product_id
  has_many :collections, through: 'collects'

  def size_variant(size)
    variants.find_by(option1: size)
  end
end
