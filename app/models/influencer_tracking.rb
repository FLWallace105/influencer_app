class InfluencerTracking < ApplicationRecord
  has_many(:orders, class_name: 'InfluencerOrder', foreign_key: 'name',
                    primary_key: 'order_name')

  def influencer
    orders.first.influencer
  rescue
    nil
  end

  def email_data
    {
      influencer_id: order.influencer_id,
      carrier: carrier,
      tracking_num: tracking_number
    }
  end

  def email_sent?
    !email_sent_at.nil?
  end
end
