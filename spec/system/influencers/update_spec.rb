require 'rails_helper'

RSpec.describe "Influencers Update" do
  context 'when a user is signed in' do
    describe 'successfully updates an influencer' do
      it 'changes the influencer correctly in the database' do
        influencer = create(:influencer, :with_collection, first_name: 'Mary')
        user = create(:user)
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        click_on influencer.first_name
        fill_in 'First name', with: 'Jane'
        click_on 'Update Influencer'

        expect_to_see "Successfully updated Jane #{influencer.last_name}."
        expect(influencer.reload.first_name).to eq 'Jane'
      end

      it 'shows the new attributes in the form' do
        influencer = create(:influencer, :with_collection, last_name: 'Mary')
        user = create(:user)
        login(user)
        visit edit_influencer_path influencer
        fill_in 'Last name', with: 'Jane'
        click_on 'Update Influencer'

        expect_to_see "Successfully updated #{influencer.first_name} Jane."
        expect(find('#influencer_last_name').value).to eq 'Jane'
        expect(influencer.reload.last_name).to eq 'Jane'
      end
    end

    describe 'unsuccessfully updates an influencer' do
      it 'shows the correct error messages' do
        influencer = create(:influencer, :with_collection)
        user = create(:user)
        login(user)
        visit edit_influencer_path influencer
        fill_in 'First name', with: ''
        click_on 'Update Influencer'

        expect_to_see "can't be blank"
      end

      it 'does not update the influencer when validations fail' do
        influencer = create(:influencer, :with_collection, last_name: 'Mary')
        user = create(:user)
        login(user)
        visit edit_influencer_path influencer
        fill_in 'Last name', with: ''
        click_on 'Update Influencer'

        expect_to_see "can't be blank"
        expect(influencer.reload.last_name).to eq 'Mary'
      end
    end

    it 'does not save the whitespace' do
      influencer = create(:influencer, :with_collection)
      user = create(:user)
      login(user)
      visit edit_influencer_path(influencer)
      fill_in 'First name', with: ' Jane '
      fill_in 'Last name', with: '  Doe  '
      fill_in 'Address Line One', with: ' 1234 Bandini St. '
      fill_in 'Address Line Two', with: ' Unit 1234 '
      fill_in 'City', with: ' Los Angeles'
      fill_in 'State', with: ' CA '
      fill_in 'Zip', with: ' 90210 '
      fill_in 'Email', with: ' jane@doe.com '
      fill_in 'Phone', with: ' 1234567890 '
      fill_in 'Top size', with: ' M '
      fill_in 'Leggings size', with: ' M '
      fill_in 'Sports jacket size', with: ' M '
      fill_in 'Collection', with: ' 1234567890 '
      click_on 'Update Influencer'

      expect(influencer.reload.first_name).to eq 'Jane'
      expect(influencer.reload.last_name).to eq 'Doe'
      expect(influencer.reload.address1).to eq '1234 Bandini St.'
      expect(influencer.reload.address2).to eq 'Unit 1234'
      expect(influencer.reload.city).to eq 'Los Angeles'
      expect(influencer.reload.state).to eq 'CA'
      expect(influencer.reload.zip).to eq '90210'
      expect(influencer.reload.email).to eq 'jane@doe.com'
      expect(influencer.reload.phone).to eq '1234567890'
      expect(influencer.reload.bra_size).to eq 'M'
      expect(influencer.reload.top_size).to eq 'M'
      expect(influencer.reload.bottom_size).to eq 'M'
      expect(influencer.reload.sports_jacket_size).to eq 'M'
      expect(influencer.reload.collection_id).to eq 1234567890
    end
  end
end
