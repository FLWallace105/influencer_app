require 'rails_helper'
RSpec.describe "Influencer Orders Create" do
  context 'when a user is signed in' do
    describe 'successfully creates influencer orders' do
      it 'creates one influencer order' do
        product = create(:product, :leggings, :with_collection_and_variants)
        influencer = create(:influencer, collection_id: product.collections.first.id, bottom_size: 'XL')
        user = create(:user)

        visit new_user_session_path
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        find(:css, "#influencers_[value='#{influencer.id}']").set(true)
        click_on 'Create Orders'
        # page.accept_alert # required if you run the test with javascript enabled

        expect_to_see '1 product queued to ship.'
        expect(InfluencerOrder.count).to eq 1
      end

      it 'creates three influencer orders' do
        custom_collection = create(:custom_collection, :with_three_products)
        influencer = create(
          :influencer,
          collection_id: custom_collection.id,
          top_size: 'S',
          bottom_size: 'M',
          bra_size: 'XL'
        )
        user = create(:user)

        visit new_user_session_path
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        find(:css, "#influencers_[value='#{influencer.id}']").set(true)
        click_on 'Create Orders'
        # page.accept_alert # required if you run the test with javascript enabled

        expect_to_see '3 products queued to ship.'
        expect(InfluencerOrder.count).to eq 3
      end

      it 'shows the influencers in the influencers index page' do
        product = create(:product, :leggings, :with_collection_and_variants)
        influencer = create(:influencer, collection_id: product.collections.first.id, bottom_size: 'XL')
        user = create(:user)

        visit new_user_session_path
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        find(:css, "#influencers_[value='#{influencer.id}']").set(true)
        click_on 'Create Orders'
        # page.accept_alert # required if you run the test with javascript enabled

        expect_to_see influencer.first_name
        expect_to_see influencer.address1
        expect_to_see influencer.state
      end

      it 'creates the same order name for all orders belonging to an influencer and different order names for each influencer' do
        custom_collection = create(:custom_collection, :with_three_products)
        influencer1 = create(
          :influencer,
          collection_id: custom_collection.id,
          top_size: 'S',
          bottom_size: 'M',
          bra_size: 'XL'
        )
        influencer2 = create(
          :influencer,
          collection_id: custom_collection.id,
          top_size: 'S',
          bottom_size: 'M',
          bra_size: 'XL'
        )
        user = create(:user)

        visit new_user_session_path
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        find(:css, "#influencers_[value='#{influencer1.id}']").set(true)
        find(:css, "#influencers_[value='#{influencer2.id}']").set(true)
        click_on 'Create Orders'
        # page.accept_alert # required if you run the test with javascript enabled
        first_order_group = InfluencerOrder.where(influencer: Influencer.first)
        second_order_group = InfluencerOrder.where(influencer: Influencer.second)

        expect_to_see '6 products queued to ship.'
        expect(InfluencerOrder.count).to eq 6
        expect(first_order_group.pluck(:name).uniq.count).to eq 1
        expect(second_order_group.pluck(:name).uniq.count).to eq 1
        expect(first_order_group.pluck(:name).first).not_to eq second_order_group.pluck(:name).first
      end

      it 'creates five influencer orders' do
        custom_collection = create(:custom_collection, :with_five_products)
        influencer = create(
          :influencer,
          collection_id: custom_collection.id,
          top_size: 'S',
          bottom_size: 'M',
          bra_size: 'XL'
        )
        user = create(:user)

        visit new_user_session_path
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        find(:css, "#influencers_[value='#{influencer.id}']").set(true)
        click_on 'Create Orders'
        # page.accept_alert # required if you run the test with javascript enabled

        expect_to_see '5 products queued to ship.'
        expect(InfluencerOrder.count).to eq 5
      end

      specify 'each order is for a different product' do
        custom_collection = create(:custom_collection, :with_five_products)
        influencer = create(
          :influencer,
          collection_id: custom_collection.id,
          top_size: 'S',
          bottom_size: 'M',
          bra_size: 'XL'
        )
        user = create(:user)

        visit new_user_session_path
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        find(:css, "#influencers_[value='#{influencer.id}']").set(true)
        click_on 'Create Orders'
        # page.accept_alert # required if you run the test with javascript enabled

        expect(InfluencerOrder.all.pluck(:line_item).map { |line_item| line_item["product_id"] }.uniq.count).to eq 5
      end

      it 'creates orders for every influencer on the page when the SelectAll checkbox is checked', :js do
        # This test assumes only 100 influencers are shown per page.
        # It also requires javascript to be turned on.

        product = create(:product, :leggings, :with_collection_and_variants)
        120.times do
          create(:influencer, collection_id: product.collections.first.id, bottom_size: 'XL')
        end

        user = create(:user)

        visit new_user_session_path
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        find(:css, "#Select_All").set(true)
        click_on 'Create Orders'
        page.accept_alert
        sleep 2
        expect_to_see '100 products queued to ship.'
        expect(InfluencerOrder.count).to eq 100
      end

      it 'creates orders for the correct influencers' do
        influencer1 = create(
          :influencer,
          :with_collection
        )
        create(
          :influencer,
          :with_collection
        )
        influencer3 = create(
          :influencer,
          :with_collection
        )
        create(
          :influencer,
          :with_collection
        )
        user = create(:user)

        visit new_user_session_path
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        find(:css, "#influencers_[value='#{influencer1.id}']").set(true)
        find(:css, "#influencers_[value='#{influencer3.id}']").set(true)
        click_on 'Create Orders'
        # page.accept_alert # required if you run the test with javascript enabled

        expect_to_see '6 products queued to ship.'
        expect(InfluencerOrder.count).to eq 6
        expect(Influencer.find(influencer1.id).orders.count).to eq 3
        expect(Influencer.find(influencer3.id).orders.count).to eq 3
      end
    end
  end

  describe 'unsuccessfully creates influencer orders' do
    # WARNING: I shouldn't be using a stub below. The purpose of system/integration tests
    # is to test the whole system, whereas the purpose of mocks/stubs/spies is
    # to isolate parts of the system. If you use them in system/integration tests, then
    # strange, hard to debug, bugs can occur.
    it 'shows the email of the influencer whose order failed to be created along with the error message' do
      product = create(:product, :leggings, :with_collection_and_variants)
      influencer = create(:influencer, collection_id: product.collections.first.id, bottom_size: 'XL')
      Influencer.any_instance.stub(:shipping_address).and_return(nil)
      user = create(:user)

      visit new_user_session_path
      login(user)
      within '#influencers_dropdown' do
        click_on 'Influencers'
      end
      click_on 'View Influencers'
      find(:css, "#influencers_[value='#{influencer.id}']").set(true)
      click_on 'Create Orders'
      # page.accept_alert # required if you run the test with javascript enabled

      expect_to_see '0 products queued to ship.'
      expect(InfluencerOrder.count).to eq 0
      expect_to_see("#{Influencer.first.email} - Shipping address can't be blank")
      "0 products queued to ship."

      expect_to_see influencer.first_name
      expect_to_see influencer.address1
      expect_to_see influencer.state
    end

    it 'does not create orders for influencers who are inactive' do
      create(:influencer, :with_collection, active: false)
      user = create(:user)

      visit new_user_session_path
      login(user)
      within '#influencers_dropdown' do
        click_on 'Influencers'
      end
      click_on 'View Influencers'
      click_on "Create Orders"

      expect_to_see '0 products queued to ship.'
      expect(InfluencerOrder.count).to eq 0
    end
  end
end
