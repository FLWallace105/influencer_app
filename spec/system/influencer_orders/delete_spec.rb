require 'rails_helper'

RSpec.describe "InfluencerOrders Delete" do
  context 'when a user is signed in' do
    describe 'successfully deletes influencer orders' do
      it 'deletes the correct influencer orders when their is only one order name per order' do
        influencer1 = create(:influencer, :with_collection, :with_order)
        influencer2 = create(:influencer, :with_collection, :with_order)
        influencer3 = create(:influencer, :with_collection, :with_order)
        influencer4 = create(:influencer, :with_collection, :with_order)
        user = create(:user)
        login(user)
        visit influencer_orders_path
        find(:css, "#influencer_orders_[value='#{influencer1.id}']").set(true)
        find(:css, "#influencer_orders_[value='#{influencer3.id}']").set(true)
        click_on 'Delete Orders'
        # page.accept_alert # required if you run the test with javascript enabled

        expect_to_see '2 orders deleted.'
        expect(influencer1.reload.orders.any?).to be false
        expect(influencer2.reload.orders.any?).to be true
        expect(influencer3.reload.orders.any?).to be false
        expect(influencer4.reload.orders.any?).to eq true
      end

      it 'deletes the correct orders when there are multiple influencer order rows with the same name' do
        influencer1 = create(:influencer, :with_collection, :with_three_product_order)
        influencer2 = create(:influencer, :with_collection, :with_different_three_product_order)
        influencer3 = create(:influencer, :with_collection, :with_another_three_product_order)

        user = create(:user)
        login(user)
        visit influencer_orders_path

        find(:css, "#influencer_orders_[value='#{influencer1.orders.first.id}']").set(true)
        find(:css, "#influencer_orders_[value='#{influencer2.orders.first.id}']").set(true)
        click_on 'Delete Orders'
        # page.accept_alert # required if you run the test with javascript enabled

        expect_to_see '2 orders deleted.'
        expect(influencer1.reload.orders.any?).to be false
        expect(influencer2.reload.orders.any?).to be false
        expect(influencer3.reload.orders.count).to eq 3
      end

      it 'shows the correct number of complete orders deleted' do
        influencer1 = create(:influencer, :with_collection, :with_three_product_order)
        influencer2 = create(:influencer, :with_collection, :with_different_three_product_order)
        create(:influencer, :with_collection, :with_another_three_product_order)

        user = create(:user)
        login(user)
        visit influencer_orders_path

        find(:css, "#influencer_orders_[value='#{influencer1.orders.first.id}']").set(true)
        find(:css, "#influencer_orders_[value='#{influencer2.orders.first.id}']").set(true)
        click_on 'Delete Orders'
        # page.accept_alert # required if you run the test with javascript enabled

        expect_to_see '2 orders deleted.'
      end
    end

    describe 'unsuccessfully deletes influencer orders' do
      it "doesn't delete any orders when none are selected" do
        influencer1 = create(:influencer, :with_collection, :with_three_product_order)
        influencer2 = create(:influencer, :with_collection, :with_different_three_product_order)

        user = create(:user)
        login(user)
        visit influencer_orders_path

        click_on 'Delete Orders'
        # page.accept_alert # required if you run the test with javascript enabled

        expect(influencer1.reload.orders.count).to eq 3
        expect(influencer2.reload.orders.count).to eq 3
      end

      it 'shows zero orders were deleted' do
        create(:influencer, :with_collection, :with_three_product_order)
        create(:influencer, :with_collection, :with_different_three_product_order)

        user = create(:user)
        login(user)
        visit influencer_orders_path

        click_on 'Delete Orders'
        # page.accept_alert # required if you run the test with javascript enabled

        expect_to_see '0 orders deleted.'
      end
    end
  end
end
