require 'rails_helper'
RSpec.describe "Influencer Orders Create Once A Month" do
  context 'when a user is signed in' do
    describe 'successfully creates influencer orders' do
      it 'creates orders when an influencer was created last month and then updated this month' do
        custom_collection = create(:custom_collection, :with_three_products)
        Timecop.freeze(1.month.ago.end_of_month) do
          create(
            :influencer,
            collection_id: custom_collection.id,
            top_size: 'S',
            bottom_size: 'M',
            bra_size: 'XL'
          )
        end
        Timecop.return
        Influencer.first.update(top_size: 'M')
        user = create(:user)

        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        click_on "Create This Month's Influencer Orders"

        expect_to_see '3 products queued to ship.'
        expect(InfluencerOrder.count).to eq 3
      end

      it 'creates orders at the end of the month when an influencer was created in the begining of the month' do
        custom_collection = create(:custom_collection, :with_three_products)
        Timecop.freeze(Date.today.beginning_of_month) do
          create(
            :influencer,
            collection_id: custom_collection.id,
            top_size: 'S',
            bottom_size: 'M',
            bra_size: 'XL'
          )
        end
        Timecop.return
        Timecop.freeze(Date.today.end_of_month) do
          user = create(:user)

          login(user)
          within '#influencers_dropdown' do
            click_on 'Influencers'
          end
          click_on 'View Influencers'
          click_on "Create This Month's Influencer Orders"

          expect_to_see '3 products queued to ship.'
          expect(InfluencerOrder.count).to eq 3
        end
        Timecop.return
      end
    end
  end

  describe 'unsuccessfully creates influencer orders' do
    it 'does not create orders for influencers that were not updated this month or created this month' do
      custom_collection = create(:custom_collection, :with_three_products)
      Timecop.freeze(1.month.ago.end_of_month) do
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
      login(user)
      within '#influencers_dropdown' do
        click_on 'Influencers'
      end
      click_on 'View Influencers'
      click_on "Create This Month's Influencer Orders"

      expect_to_see '0 products queued to ship.'
      expect(InfluencerOrder.count).to eq 0
    end

    # WARNING: I shouldn't be using a stub below. The purpose of system/integration tests
    # is to test the whole system, whereas the purpose of mocks/stubs/spies is
    # to isolate parts of the system. If you use them in system/integration tests, then
    # strange, hard to debug, bugs can occur.
    it 'shows the email of the influencer whose order failed to be created along with the error message' do
      product = create(:product, :leggings, :with_collection_and_variants)
      create(:influencer, collection_id: product.collections.first.id, bottom_size: 'XL')
      Influencer.any_instance.stub(:shipping_address).and_return(nil)
      user = create(:user)

      login(user)
      within '#influencers_dropdown' do
        click_on 'Influencers'
      end
      click_on 'View Influencers'
      click_on "Create This Month's Influencer Orders"

      expect_to_see '0 products queued to ship.'
      expect(InfluencerOrder.count).to eq 0
      expect_to_see("#{Influencer.first.email} - Shipping address can't be blank")
    end

    it 'does not create orders when at least one order was already created this month' do
      custom_collection = create(:custom_collection, :with_five_products)

      Timecop.freeze(Time.zone.now.beginning_of_month) do
        create(
          :influencer,
          :with_order,
          collection_id: custom_collection.id,
          top_size: 'S',
          bottom_size: 'M',
          bra_size: 'XL'
        )
      end

      Timecop.return
      create(
        :influencer,
        collection_id: custom_collection.id,
        top_size: 'S',
        bottom_size: 'M',
        bra_size: 'XL'
      )
      user = create(:user)
      Timecop.freeze(Time.zone.now.end_of_month) do

        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        click_on "Create This Month's Influencer Orders"

        expect_to_see 'Influencer orders were already created this month.'
        expect(InfluencerOrder.count).to eq 1
      end
      Timecop.return
    end
  end

  it 'does not create orders for influencers who were updated this month, but inactive' do
    create(:influencer, :with_collection, active: false)
    user = create(:user)
    login(user)
    within '#influencers_dropdown' do
      click_on 'Influencers'
    end
    click_on 'View Influencers'
    click_on "Create This Month's Influencer Orders"

    expect_to_see '0 products queued to ship.'
    expect(InfluencerOrder.count).to eq 0
  end

  it 'does not create orders for influencers with collection_ids not in the database' do
    create(
      :influencer,
      collection_id: 1234567890,
      top_size: 'S',
      bottom_size: 'M',
      bra_size: 'XL'
    )
    user = create(:user)

    login(user)
    visit influencers_path
    click_on "Create This Month's Influencer Orders"
    # page.accept_alert # required if you run the test with javascript enabled

    expect_to_see '0 products queued to ship.'
    expect(InfluencerOrder.count).to eq 0
  end
end
