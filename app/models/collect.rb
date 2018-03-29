class Collect < ApplicationRecord
  belongs_to :product
  belongs_to :collection, class_name: 'CustomCollection'
end
