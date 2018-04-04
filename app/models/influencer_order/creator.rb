class InfluencerOrder::Creator
  include ActiveModel::Model
  attr_accessor :created_count

  def process!
    @created_count = 0
    Influencer.where("updated_at >= ?", Time.zone.now.beginning_of_month).each do |influencer|
      order_number = InfluencerOrder.generate_order_number

      influencer.sized_variants_from_collection.each do |variant|
        influencer_order = InfluencerOrder.new_from_influencer_variant(
          influencer: influencer,
          variant: variant,
          shipping_method_requested: influencer.shipping_method_requested,
          order_number: order_number
        )

        if influencer_order.save
          @created_count += 1
        else
          errors.add(:base, "#{influencer.email} - #{influencer_order.errors.full_messages.join(', ')}")
        end
      end
    end
  end

  def save
    process!
    errors.none?
  end
end
