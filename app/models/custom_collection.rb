class CustomCollection < ApplicationRecord
  serialize :metafield

  has_many :collects
  has_many :products, through: 'collects'
end
