require 'rails_helper'
RSpec.describe "EllieFTP" do
  describe 'successfully uploads influencer orders' do
    it 'uploads one influencer order' do
      custom_collection = create(:custom_collection, :with_three_products)
      create(
        :influencer,
        :with_order,
        collection_id: custom_collection.id,
        top_size: 'S',
        bottom_size: 'M',
        bra_size: 'XL'
      )
      orders = InfluencerOrder.where(uploaded_at: nil)
      csv_file_name = InfluencerOrder.create_csv(orders)
      server = FakeFtp::Server.new(21212, 21213)
      server.start
      EllieFTP.new.upload_orders_csv(csv_file_name)

      expect(server.files).to include(csv_file_name)
      expect(server.store.keys.first).to eq "/EllieInfluencer/ReceiveOrder/#{csv_file_name}"
      server.stop
    end
  end
end
