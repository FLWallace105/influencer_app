require 'rails_helper'

RSpec.describe "Influencers Delete" do
  context 'when a user is signed in' do
    describe 'successfully deletes influencers' do
      it 'removes the correct influencer from the database' do
        influencer = create(:influencer, :with_collection, first_name: 'Mary')
        user = create(:user)
        visit new_user_session_path
        login(user)
        visit influencers_path
        find(:css, "#influencers_[value='#{influencer.id}']").set(true)
        click_on 'Delete Influencers'
        # page.accept_alert # required if you run the test with javascript enabled

        expect_to_see '1 influencer deleted.'
        expect(Influencer.count).to eq 0
      end

      it 'deletes the correct influencers'
      it 'shows the correct number of influencers deleted'
      it 'deletes the associated orders of the influencer'
    end

    describe 'unsuccessfully deletes an influencer' do
      it "doesn't delete any influencers when none are selected" do
        create(:influencer, :with_collection, first_name: 'Mary')
        user = create(:user)
        visit new_user_session_path
        login(user)
        visit influencers_path
        click_on 'Delete Influencers'
        # page.accept_alert # required if you run the test with javascript enabled

        expect_to_see '0 influencers deleted.'
        expect(Influencer.count).to eq 1
      end
    end
  end
end
