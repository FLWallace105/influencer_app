require 'rails_helper'

RSpec.describe "Influencers Mark Active" do
  context 'when a user is signed in' do
    describe 'successfully marks influencers active' do
      it 'marks the correct influencers active' do
        influencer1 = create(:influencer, :with_collection, active: false)
        influencer2 = create(:influencer, :with_collection, active: false)
        influencer3 = create(:influencer, :with_collection, active: false)
        influencer4 = create(:influencer, :with_collection, active: false)

        user = create(:user)
        login(user)
        visit influencers_path
        find(:css, "#influencers_[value='#{influencer1.id}']").set(true)
        find(:css, "#influencers_[value='#{influencer3.id}']").set(true)
        click_on 'Mark Active'
        # page.accept_alert # required if you run the test with javascript enabled

        expect_to_see '2 influencers marked active.'
        expect(influencer1.reload.active?).to eq true
        expect(influencer2.reload.active?).to eq false
        expect(influencer3.reload.active?).to eq true
        expect(influencer4.reload.active?).to eq false
      end
    end

    describe 'unsuccessfully marks influencers active' do
      it "doesn't mark any influencers active when none are selected" do
        influencer = create(:influencer, :with_collection, active: false)

        user = create(:user)
        login(user)
        visit influencers_path
        click_on 'Mark Active'
        # page.accept_alert # required if you run the test with javascript enabled

        expect_to_see '0 influencers marked active.'
        expect(influencer.reload.active?).to eq false
      end
    end
  end
end
