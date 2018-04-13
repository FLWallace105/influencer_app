require 'rails_helper'

RSpec.describe "Influencers Create" do
  context 'when a user is signed in' do
    describe 'successfully creates an influencer' do
      it 'saves the influencer correctly in the database' do
        create(:custom_collection, id: 1234567890)
        user = create(:user)
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'New Influencers'
        fill_in 'First name', with: 'Jane'
        fill_in 'Last name', with: 'Doe'
        fill_in 'Address Line One', with: '1234 Bandini St.'
        fill_in 'City', with: 'Los Angeles'
        fill_in 'State', with: 'CA'
        fill_in 'Zip', with: '90210'
        fill_in 'Email', with: 'jane@doe.com'
        fill_in 'Phone', with: '1234567890'
        fill_in 'Bra size', with: 'M'
        fill_in 'Top size', with: 'M'
        fill_in 'Bottom size', with: 'M'
        fill_in 'Sports jacket size', with: 'M'
        fill_in 'Collection', with: '1234567890'
        click_on 'Create Influencer'

        expect_to_see "Successfully created Jane Doe."
        influencer = Influencer.first
        expect(influencer.first_name).to eq 'Jane'
        expect(influencer.last_name).to eq 'Doe'
        expect(influencer.active?).to eq true
        expect(influencer.address1).to eq '1234 Bandini St.'
        expect(influencer.address2.present?).to be false
        expect(influencer.city).to eq 'Los Angeles'
        expect(influencer.state).to eq 'CA'
        expect(influencer.zip).to eq '90210'
        expect(influencer.email).to eq 'jane@doe.com'
        expect(influencer.phone).to eq '1234567890'
        expect(influencer.bra_size).to eq 'M'
        expect(influencer.top_size).to eq 'M'
        expect(influencer.bottom_size).to eq 'M'
        expect(influencer.sports_jacket_size).to eq 'M'
        expect(influencer.collection_id).to eq 1234567890
      end

      it 'allows the creation of an inactive influencer' do
        create(:custom_collection, id: 1234567890)
        user = create(:user)
        login(user)
        visit new_influencer_path
        fill_in 'First name', with: 'Jane'
        fill_in 'Last name', with: 'Doe'
        find(:css, "#influencer_active").set(false)
        fill_in 'Address Line One', with: '1234 Bandini St.'
        fill_in 'City', with: 'Los Angeles'
        fill_in 'State', with: 'CA'
        fill_in 'Zip', with: '90210'
        fill_in 'Email', with: 'jane@doe.com'
        fill_in 'Phone', with: '1234567890'
        fill_in 'Bra size', with: 'M'
        fill_in 'Top size', with: 'M'
        fill_in 'Bottom size', with: 'M'
        fill_in 'Sports jacket size', with: 'M'
        fill_in 'Collection', with: '1234567890'
        click_on 'Create Influencer'

        expect_to_see "Successfully created Jane Doe."
        influencer = Influencer.first

        expect(influencer.active?).to eq false
      end
    end

    describe 'unsuccessfully updates an influencer' do
      it 'shows the correct error message' do
        create(:custom_collection, id: 1234567890)
        user = create(:user)
        login(user)
        visit new_influencer_path
        fill_in 'Collection', with: '1234567890'
        click_on 'Create Influencer'

        expect_to_see "can't be blank"
      end

      it 'does not create an influencer' do
        user = create(:user)
        login(user)
        visit new_influencer_path
        click_on 'Create Influencer'

        expect(Influencer.count).to eq 0
      end
    end

    context 'when the shopify cache is not up to date or the collection_id is wrong' do
      it 'does not create an influencer' do
        user = create(:user)
        login(user)
        visit new_influencer_path
        fill_in 'First name', with: 'Jane'
        fill_in 'Last name', with: 'Doe'
        find(:css, "#influencer_active").set(false)
        fill_in 'Address Line One', with: '1234 Bandini St.'
        fill_in 'City', with: 'Los Angeles'
        fill_in 'State', with: 'CA'
        fill_in 'Zip', with: '90210'
        fill_in 'Email', with: 'jane@doe.com'
        fill_in 'Phone', with: '1234567890'
        fill_in 'Bra size', with: 'M'
        fill_in 'Top size', with: 'M'
        fill_in 'Bottom size', with: 'M'
        fill_in 'Sports jacket size', with: 'M'
        fill_in 'Collection', with: '1234567890'
        click_on 'Create Influencer'

        expect(Influencer.count).to eq 0
      end

      it 'asks the user to refresh the Shopify cache or revise the collection_id' do
        user = create(:user)
        login(user)
        visit new_influencer_path
        fill_in 'First name', with: 'Jane'
        fill_in 'Last name', with: 'Doe'
        find(:css, "#influencer_active").set(false)
        fill_in 'Address Line One', with: '1234 Bandini St.'
        fill_in 'City', with: 'Los Angeles'
        fill_in 'State', with: 'CA'
        fill_in 'Zip', with: '90210'
        fill_in 'Email', with: 'jane@doe.com'
        fill_in 'Phone', with: '1234567890'
        fill_in 'Bra size', with: 'M'
        fill_in 'Top size', with: 'M'
        fill_in 'Bottom size', with: 'M'
        fill_in 'Sports jacket size', with: 'M'
        fill_in 'Collection', with: '1234567890'
        click_on 'Create Influencer'

        expect_to_see "The Shopify cache is not up to date or the collection_id is wrong. Please check the collection_id is correct and refresh the Shopify cache."
      end
    end
  end
end
