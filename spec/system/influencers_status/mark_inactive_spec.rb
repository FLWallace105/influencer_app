require 'rails_helper'

RSpec.describe "Influencers Mark Inactive" do
  context 'when a user is signed in' do
    describe 'successfully marks influencers inactive' do
      it 'marks the correct influencers inactive' do
        influencer1 = create(:influencer, :with_collection)
        influencer2 = create(:influencer, :with_collection)
        influencer3 = create(:influencer, :with_collection)
        influencer4 = create(:influencer, :with_collection)

        user = create(:user)
        visit new_user_session_path
        login(user)
        visit influencers_path
        find(:css, "#influencers_[value='#{influencer1.id}']").set(true)
        find(:css, "#influencers_[value='#{influencer3.id}']").set(true)
        click_on 'Mark Inactive'
        # page.accept_alert # required if you run the test with javascript enabled

        expect_to_see '2 influencers marked inactive.'
        expect(influencer1.reload.active?).to eq false
        expect(influencer2.reload.active?).to eq true
        expect(influencer3.reload.active?).to eq false
        expect(influencer4.reload.active?).to eq true
      end
    end

    describe 'unsuccessfully marks influencers inactive' do
      it "doesn't mark any influencers active when none are selected" do
        influencer = create(:influencer, :with_collection)

        user = create(:user)
        visit new_user_session_path
        login(user)
        visit influencers_path
        click_on 'Mark Inactive'
        # page.accept_alert # required if you run the test with javascript enabled

        expect_to_see '0 influencers marked inactive.'
        expect(influencer.reload.active?).to eq true
      end
    end
  end
end
