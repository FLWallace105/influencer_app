class CustomCollection < ApplicationRecord

  serialize :metafield

  has_many :collects, primary_key: :collection_id, foreign_key: :collection_id
  has_many :products, through: :collects
end
