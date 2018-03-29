class InfluencerTracking < ApplicationRecord
  has_many(:orders, class_name: 'InfluencerOrder', foreign_key: 'name',
                    primary_key: 'order_name')
end
