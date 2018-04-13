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
  end
end
