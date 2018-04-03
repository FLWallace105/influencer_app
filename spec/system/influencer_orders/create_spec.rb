require 'rails_helper'
RSpec.describe "Influencer Orders Create" do
  context 'when a user is signed in' do
    describe 'successfully creates influencer orders', :js do
      it 'creates one influencer order' do
        product = create(:product, :leggings, :with_collection_and_variants)
        create(:influencer, collection_id: product.collections.first.id, bottom_size: 'XL')
        user = create(:user)

        visit new_user_session_path
        login(user)
        within '#orders_dropdown' do
          click_on 'Orders'
        end
        click_on 'New Influencer Orders'
        click_on 'Create Influencer Orders'

        expect_to_see '1 product queued to ship.'
        expect(InfluencerOrder.count).to eq 1
      end

      it 'creates three influencer orders' do
        custom_collection = create(:custom_collection, :with_three_products)
        create(
          :influencer,
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
        click_on 'New Influencer Orders'
        click_on 'Create Influencer Orders'

        expect_to_see '3 products queued to ship.'
        expect(InfluencerOrder.count).to eq 3
      end

      it 'creates the same order name for all orders belonging to an influencer and different order names for each influencer' do
        custom_collection = create(:custom_collection, :with_three_products)
        create(
          :influencer,
          collection_id: custom_collection.id,
          top_size: 'S',
          bottom_size: 'M',
          bra_size: 'XL'
        )
        create(
          :influencer,
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
        click_on 'New Influencer Orders'
        click_on 'Create Influencer Orders'
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
        create(
          :influencer,
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
        click_on 'New Influencer Orders'
        click_on 'Create Influencer Orders'

        expect_to_see '5 products queued to ship.'
        expect(InfluencerOrder.count).to eq 5
      end
    end
  end

  describe 'unsuccessfully creates influencer orders', :js do
    it 'does not create orders for influencers that were not updated today or created today' do
      custom_collection = create(:custom_collection, :with_three_products)
      Timecop.freeze(Date.today - 1) do
        create(
          :influencer,
          collection_id: custom_collection.id,
          top_size: 'S',
          bottom_size: 'M',
          bra_size: 'XL'
        )
      end
      Timecop.return

      user = create(:user)

      visit new_user_session_path
      login(user)
      within '#orders_dropdown' do
        click_on 'Orders'
      end
      click_on 'New Influencer Orders'
      click_on 'Create Influencer Orders'

      expect_to_see '0 products queued to ship.'
      expect(InfluencerOrder.count).to eq 0
    end

    it 'shows the email of the influencer whose order failed to be created along with the error message'
  end
end
