class ProductVariant < ApplicationRecord

  serialize :metafield
  belongs_to :product, primary_key: :product_id, foreign_key: :product_id


  # for all? of our products the option1 is a size property. alias it as such
  # here so its meaning is convayed throughout the codebase
  def size
    option1
  end
end
