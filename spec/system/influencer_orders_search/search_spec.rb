require 'rails_helper'

RSpec.describe "InfluencerOrders Search" do
  context 'when a user is signed in' do
    describe 'search for an order' do
      it 'shows the users query in the search field' do
        user = create(:user)
        login(user)
        within '#orders_dropdown' do
          click_on 'Orders'
        end
        click_on 'View Influencer Orders'
        fill_in "order name or influencer's name", with: "Ashley"
        click_on 'Search'
        expect(find("input[name='query']").value).to eq 'Ashley'
      end

      it "shows the order if the order's influencer full name matches the query" do
        influencer = create(
          :influencer,
          :with_collection,
          :with_order,
          first_name: 'Ashley',
          last_name: 'Green'
        )

        user = create(:user)
        login(user)
        visit influencer_orders_path
        fill_in "order name or influencer's name", with: "Ashley Green"
        click_on 'Search'

        expect_to_see influencer.full_name
      end

      it "shows the order if the order's influencer first name matches the query" do
        influencer = create(
          :influencer,
          :with_collection,
          :with_order,
          first_name: 'Rene',
          last_name: 'Descartes'
        )
        user = create(:user)
        login(user)
        visit influencer_orders_path
        fill_in "order name or influencer's name", with: "Rene"
        click_on 'Search'

        expect_to_see influencer.full_name
      end

      it "shows the order if the order's influencer last name matches the query" do
        influencer = create(
          :influencer,
          :with_collection,
          :with_order,
          first_name: 'Rene',
          last_name: 'Descartes'
        )
        user = create(:user)
        login(user)
        visit influencer_orders_path
        fill_in "order name or influencer's name", with: "Descartes"
        click_on 'Search'

        expect_to_see influencer.full_name
      end

      it "shows the order if the order's name matches the query" do
        influencer = create(
          :influencer,
          :with_collection,
          :with_order,
          first_name: 'Rene',
          last_name: 'Descartes'
        )
        user = create(:user)
        login(user)
        visit influencer_orders_path
        influencer_order_name = InfluencerOrder.first.name
        fill_in "order name or influencer's name", with: influencer_order_name
        click_on 'Search'

        expect_to_see influencer.full_name
      end

      it "does not show any orders if none match the query" do
        influencer = create(
          :influencer,
          :with_collection,
          :with_order,
          first_name: 'Rene',
          last_name: 'Descartes'
        )
        user = create(:user)
        login(user)
        visit influencer_orders_path
        fill_in "order name or influencer's name", with: 'Aristotle'
        click_on 'Search'

        expect_not_to_see influencer.full_name
      end

      it "shows all the orders if the query is empty", :js do
        influencer1 = create(
          :influencer,
          :with_collection,
          :with_order
        )

        influencer2 = create(
          :influencer,
          :with_collection,
          :with_order
        )

        influencer3 = create(
          :influencer,
          :with_collection,
          :with_order
        )

        user = create(:user)
        login(user)
        visit influencer_orders_path
        fill_in "order name or influencer's name", with: ''
        click_on 'Search'

        expect_to_see influencer1.full_name
        expect_to_see influencer2.full_name
        expect_to_see influencer3.full_name
      end

      it "ignores whitespace in the query" do
        influencer = create(
          :influencer,
          :with_collection,
          :with_order,
          first_name: 'Rene',
          last_name: 'Descartes'
        )
        user = create(:user)
        login(user)
        visit influencer_orders_path
        fill_in "order name or influencer's name", with: '    Descartes    '
        click_on 'Search'

        expect_to_see influencer.full_name
      end

      it "only shows one order per order name on the index page" do
        influencer1 = create(
          :influencer,
          :with_collection,
          :with_three_product_order
        )

        influencer2 = create(
          :influencer,
          :with_collection,
          :with_different_three_product_order
        )


        user = create(:user)
        login(user)
        visit influencer_orders_path

        expect(page).to have_content(influencer1.orders.first.name, count: 1)
        expect(page).to have_content(influencer2.orders.first.name, count: 1)
      end

      it "only shows one order per order name after a search" do
        influencer1 = create(
          :influencer,
          :with_collection,
          :with_three_product_order
        )

        influencer2 = create(
          :influencer,
          :with_collection,
          :with_different_three_product_order
        )

        user = create(:user)
        login(user)
        visit influencer_orders_path
        fill_in "order name or influencer's name", with: influencer1.orders.first.name
        click_on 'Search'

        expect(page).to have_content(influencer1.orders.first.name, count: 1)
        expect(page).to have_content(influencer2.orders.first.name, count: 0)
      end
    end
  end
end
