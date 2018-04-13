require 'rails_helper'
RSpec.describe "Influencers Import" do
  context 'when a user is signed in' do
    describe 'successfully creates influencers' do
      it 'creates one influencer' do
        create(:custom_collection, id: 5304844306)
        user = create(:user)
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'New Influencers'
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_valid_influencer.csv")
        click_on 'Upload Influencers'

        expect(Influencer.count).to eq 1
        expect_to_see 'Imported 1 influencer.'
      end

      it 'saves all the attributes correctly' do
        user = create(:user)
        create(:custom_collection, id: 5304844306)
        login(user)
        visit new_influencer_path
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_valid_influencer.csv")
        click_on 'Upload Influencers'

        influencer = Influencer.first
        expect(influencer.first_name).to eq 'test'
        expect(influencer.last_name).to eq 'Yudkin'
        expect(influencer.active?).to eq true
        expect(influencer.address1).to eq '5553-B Bandini Blvd'
        expect(influencer.address2.present?).to be false
        expect(influencer.city).to eq 'Bell'
        expect(influencer.state).to eq 'CA'
        expect(influencer.zip).to eq '90201'
        expect(influencer.email).to eq 'tester1@gmail.com'
        expect(influencer.phone).to eq '1234567890'
        expect(influencer.bra_size).to eq 'M'
        expect(influencer.top_size).to eq 'M'
        expect(influencer.bottom_size).to eq 'M'
        expect(influencer.sports_jacket_size).to eq 'M'
        expect(influencer.collection_id).to eq 5304844306
      end

      it 'does not create an influencer_order' do
        create(:custom_collection, id: 5304844306)
        user = create(:user)
        login(user)
        visit new_influencer_path
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_valid_influencer.csv")
        click_on 'Upload Influencers'
        expect(InfluencerOrder.count).to eq 0

        expect_to_see 'Imported 1 influencer.'
      end

      it 'creates many influencers' do
        user = create(:user)
        create(:custom_collection, id: 5304844306)
        login(user)
        visit new_influencer_path
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/three_valid_influencers.csv")
        click_on 'Upload Influencers'
        expect(Influencer.count).to eq 3

        expect_to_see 'Imported 3 influencers.'
      end

      it 'updates the updated_at column even if nothing is different in the csv row from the database' do
        user = create(:user)
        create(:custom_collection, id: 5304844306)
        login(user)
        visit new_influencer_path
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_valid_influencer.csv")
        click_on 'Upload Influencers'
        first_updated_at_value = Influencer.first.updated_at

        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'New Influencers'
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_valid_influencer.csv")
        click_on 'Upload Influencers'

        expect(Influencer.first.updated_at).not_to eq first_updated_at_value
      end

      it 'updates the active column to true when importing an influencer that already exists the database.' do
        user = create(:user)
        create(:custom_collection, id: 5304844306)
        login(user)
        visit new_influencer_path
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_valid_influencer.csv")
        click_on 'Upload Influencers'
        Influencer.first.update(active: false)

        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'New Influencers'
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_valid_influencer.csv")
        click_on 'Upload Influencers'

        expect(Influencer.first.active?).to be true
      end

      it 'creates influencers when the sizes are downcased' do
        user = create(:user)
        create(:custom_collection, id: 5304844306)
        login(user)
        visit new_influencer_path
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/influencer_with_downcased_sizes.csv")
        click_on 'Upload Influencers'

        expect(Influencer.count).to eq 1
        expect_to_see 'Imported 1 influencer.'
      end

      it 'upcases the sizes when they are downcased in the csv' do
        user = create(:user)
        create(:custom_collection, id: 5304844306)
        login(user)
        visit new_influencer_path
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/influencer_with_downcased_sizes.csv")
        click_on 'Upload Influencers'

        influencer = Influencer.first
        expect(influencer.bra_size).to eq influencer.bra_size.upcase
        expect(influencer.top_size).to eq influencer.top_size.upcase
        expect(influencer.bottom_size).to eq influencer.bottom_size.upcase
        expect(influencer.sports_jacket_size).to eq influencer.sports_jacket_size.upcase
        expect_to_see 'Imported 1 influencer.'
      end

      it 'strips the whitespace from the csv data' do
        user = create(:user)
        create(:custom_collection, id: 5304844306)
        login(user)
        visit new_influencer_path
        attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_influencer_with_whitespace_in_columns.csv")
        click_on 'Upload Influencers'

        influencer = Influencer.first
        expect(influencer.bra_size).to eq influencer.bra_size.strip
        expect(influencer.top_size).to eq influencer.top_size.strip
        expect(influencer.bottom_size).to eq influencer.bottom_size.strip
        expect(influencer.sports_jacket_size).to eq influencer.sports_jacket_size.strip
        expect_to_see 'Imported 1 influencer.'
      end
    end
  end

  describe 'unsuccessfully imports influencers from csv' do
    it 'is able to find influencers by email when there is whitespace around the email in the csv' do
      product = create(:product, :leggings, :with_collection_and_variants)
      create(:influencer, collection_id: product.collections.first.id, email: 'tester1@gmail.com')
      create(:custom_collection, id: 5304844306)
      user = create(:user)
      login(user)
      visit new_influencer_path
      attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_influencer_with_whitespace_in_columns.csv")
      click_on 'Upload Influencers'

      expect(Influencer.count).to eq 1
      expect_to_see 'Line 2 - tester1@gmail.com, Email has already been taken'
    end

    it 'does not create influencers with invalid emails' do
      user = create(:user)
      create(:custom_collection, id: 5304844306)
      login(user)
      visit new_influencer_path
      attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_influencer_with_invalid_email.csv")
      click_on 'Upload Influencers'

      expect(Influencer.count).to eq 0
      expect_to_see 'Line 2 - invalid_at_email_dot_com, Email is invalid'
    end

    it 'shows the correct count of unsuccessful imports and the correct error message with the line in the csv file that the error is in' do
      create(:custom_collection, id: 5304844306)
      user = create(:user)
      login(user)
      visit new_influencer_path
      attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_invalid_influencer.csv")
      click_on 'Upload Influencers'
      expect(Influencer.count).to eq 0

      expect_to_see 'There were errors with your CSV file. Imported 0 influencers.'
      expect_to_see "Line 2 - tester1@gmail.com, First name can't be blank"
    end

    it 'creates influencers from valid csv rows and does not create influencers from invalid csv rows' do
      create(:custom_collection, id: 5304844306)
      user = create(:user)
      login(user)
      visit new_influencer_path
      attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_valid_and_two_invalid_influencers.csv")
      click_on 'Upload Influencers'
      expect(Influencer.count).to eq 1

      expect_to_see 'There were errors with your CSV file. Imported 1 influencer.'
      expect_to_see "Line 3 - tester2@gmail.com, First name can't be blank"
      expect_to_see "Line 4 - , Email can't be blank"
    end

    it 'does not create influencers with invalid sizes' do
      create(:custom_collection, id: 5304844306)
      user = create(:user)
      login(user)
      visit new_influencer_path
      attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/influencer_with_invalid_sizes.csv")
      click_on 'Upload Influencers'
      expect(Influencer.count).to eq 0

      expect_to_see 'There were errors with your CSV file. Imported 0 influencers.'
      expect_to_see "Line 2 - tester1@gmail.com, Bra size is not included in the list, Top size is not included in the list, Bottom size is not included in the list, Sports jacket size is not included in the list"
    end

    it 'does not create an influencer when one already exists with the same email' do
      create(:custom_collection, id: 5304844306)
      user = create(:user)
      login(user)
      visit new_influencer_path
      attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/two_influencers_with_identical_emails.csv")
      click_on 'Upload Influencers'

      expect(Influencer.count).to eq 1
      expect_to_see 'Imported 1 influencer. Updated 1 influencer.'
    end

    it 'does not create an influencer when one already exists with the same shipping address' do
      create(:custom_collection, id: 5304844306)
      user = create(:user)
      login(user)
      visit new_influencer_path
      attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/two_influencers_with_identical_shipping_addresses.csv")
      click_on 'Upload Influencers'

      expect(Influencer.count).to eq 1
      expect_to_see 'There were errors with your CSV file. Imported 1 influencer. Updated 0 influencers.'
      expect_to_see 'Line 3 - tester2@gmail.com, Shipping address must be unique.'
    end

    it 'does not create an influencer when one already exists with the same shipping address even if the csv has whitespace in the address data' do
      create(:custom_collection, id: 5304844306)
      user = create(:user)
      login(user)
      visit new_influencer_path
      attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/two_influencers_with_identical_shipping_addresses_one_with_whitespace.csv")
      click_on 'Upload Influencers'

      expect(Influencer.count).to eq 1
      expect_to_see 'There were errors with your CSV file. Imported 1 influencer. Updated 0 influencers.'
      expect_to_see 'Line 3 - tester2@gmail.com, Shipping address must be unique.'
    end
  end

  context 'when the shopify cache is not up to date or the collection_id is wrong' do
    it 'shows the line in the csv where the collection_id is not found' do
      user = create(:user)
      login(user)
      visit new_influencer_path
      attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_valid_influencer.csv")
      click_on 'Upload Influencers'

      expect_to_see 'There were errors with your CSV file. Imported 0 influencers. Updated 0 influencers.'
      expect_to_see 'Line 2 - tester1@gmail.com, Collection id not found.'
    end

    it 'does not create the influencer for that row' do
      user = create(:user)
      login(user)
      visit new_influencer_path
      attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/one_valid_influencer.csv")
      click_on 'Upload Influencers'

      expect(Influencer.count).to eq 0
    end

    it 'is able to create influencers with the correct collection_id and skip those with the wrong collection_id' do
      create(:custom_collection, id: 1234567890)
      user = create(:user)
      login(user)
      visit new_influencer_path
      attach_file("influencer_import_file", Rails.root + "spec/support/csv_files/two_influencers_with_different_collection_ids.csv")
      click_on 'Upload Influencers'

      expect_to_see 'There were errors with your CSV file. Imported 1 influencer. Updated 0 influencers.'
      expect_to_see 'Line 2 - tester1@gmail.com, Collection id not found.'
      expect(Influencer.count).to eq 1
    end
  end
end
