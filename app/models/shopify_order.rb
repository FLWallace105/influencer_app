class ShopifyOrder < ApplicationRecord
  serialize :line_items
  serialize :shipping_lines
  serialize :tax_lines
end
