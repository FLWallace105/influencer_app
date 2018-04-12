require 'rails_helper'

describe InfluencerOrder do
  describe '#set_influencer_full_name' do
    it "sets the full name of the associated user" do
      influencer = create(:influencer, :with_collection, first_name: 'Rene', last_name: 'Descartes')
      order_number = InfluencerOrder.generate_order_number

      influencer.sized_variants_from_collection.each do |variant|
        influencer_order = InfluencerOrder.new_from_influencer_variant(
          influencer: influencer,
          variant: variant,
          shipping_method_requested: influencer.shipping_method_requested,
          order_number: order_number
        )

        influencer_order.save
      end

      expect(InfluencerOrder.first.influencer_full_name).to eq 'Rene Descartes'
    end
  end
end
