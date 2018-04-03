require 'rails_helper'
RSpec.describe "Influencers Import" do
  context 'when a user is signed in' do
    describe 'successfully imports influencers from csv' do
      it 'creates one influencer' do
        user = create(:user)
        visit new_user_session_path
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'Upload CSV'
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_valid_influencer.csv")
        click_on 'Upload Influencers'
        expect(Influencer.count).to eq 1

        expect_to_see 'Imported 1 influencer.'
      end

      it 'does not create an influencer_order' do
        user = create(:user)
        visit new_user_session_path
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'Upload CSV'
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_valid_influencer.csv")
        click_on 'Upload Influencers'
        expect(InfluencerOrder.count).to eq 0

        expect_to_see 'Imported 1 influencer.'
      end

      it 'creates many influencers' do
        user = create(:user)
        visit new_user_session_path
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'Upload CSV'
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/three_valid_influencers.csv")
        click_on 'Upload Influencers'
        expect(Influencer.count).to eq 3

        expect_to_see 'Imported 3 influencers.'
      end

      it 'updates the updated_at column even if nothing is different in the csv row from the database' do
        user = create(:user)
        visit new_user_session_path
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'Upload CSV'
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_valid_influencer.csv")
        click_on 'Upload Influencers'
        first_updated_at_value = Influencer.first.updated_at

        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'Upload CSV'
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_valid_influencer.csv")
        click_on 'Upload Influencers'

        expect(Influencer.first.updated_at).not_to eq first_updated_at_value
      end
    end
  end

  describe 'unsuccessfully imports influencers from csv' do
    it 'shows the correct count of unsuccessful imports and the correct error message with the line in the csv file that the error is in' do
      user = create(:user)
      visit new_user_session_path
      login(user)
      within '#influencers_dropdown' do
        click_on 'Influencers'
      end
      click_on 'Upload CSV'
      attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_invalid_influencer.csv")
      click_on 'Upload Influencers'
      expect(Influencer.count).to eq 0

      expect_to_see 'There were errors with your CSV file. Imported 0 influencers.'
      expect_to_see "Line 2 - First name can't be blank"
    end

    it 'creates influencers from valid csv rows and does not create influencers from invalid csv rows' do
      user = create(:user)
      visit new_user_session_path
      login(user)
      within '#influencers_dropdown' do
        click_on 'Influencers'
      end
      click_on 'Upload CSV'
      attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_valid_and_two_invalid_influencers.csv")
      click_on 'Upload Influencers'
      expect(Influencer.count).to eq 1

      expect_to_see 'There were errors with your CSV file. Imported 1 influencer.'
      expect_to_see "Line 3 - First name can't be blank"
      expect_to_see "Line 4 - Email can't be blank"
    end
  end
end
