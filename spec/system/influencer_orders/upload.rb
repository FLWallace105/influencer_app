require 'rails_helper'
RSpec.describe "Influencer Orders Upload" do
  context 'when a user is signed in' do
    describe 'successfully uploads influencer orders to the warehouse' do
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
        user = create(:user)

        visit new_user_session_path
        login(user)
        within '#orders_dropdown' do
          click_on 'Orders'
        end
        server = FakeFtp::Server.new(21212, 21213)
        server.start
        click_on 'Send Influencer Orders to Warehouse'
        # page.accept_alert # you need this if you run the test with javascript enabled
        sleep 2

        expect(server.files.empty?).to be false
        expect(server.store.keys.first).to eq "/EllieInfluencer/ReceiveOrder/#{server.files.first}"
        server.stop
      end
    end

    describe 'does not upload orders to the warehouse' do
      it 'does not upload orders when an order has already been uploaded this month' do
        custom_collection = create(:custom_collection, :with_three_products)
        create(
          :influencer,
          :with_order,
          collection_id: custom_collection.id,
          top_size: 'S',
          bottom_size: 'M',
          bra_size: 'XL'
        )
        Influencer.first.orders.first.update(uploaded_at: Time.current)
        user = create(:user)

        visit new_user_session_path
        login(user)
        within '#orders_dropdown' do
          click_on 'Orders'
        end
        click_on 'Send Influencer Orders to Warehouse'
        # page.accept_alert # you need this if you run the test with javascript enabled

        expect_to_see 'There were no orders waiting to be sent to the warehouse.'
        expect(EllieFTP).not to_receive(:new)
      end
    end
  end
end
