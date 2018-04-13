require 'rails_helper'

RSpec.describe "Influencers Search" do
  context 'when a user is signed in' do
    describe 'search for an influencer' do
      it 'shows the users query in the search field'do
        user = create(:user)
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        fill_in 'email or name', with: "email@example.com"
        click_on 'Search'
        expect(find("input[name='query']").value).to eq 'email@example.com'
      end

      it "shows the influencer if the influencer's full name matches the query" do
        influencer = create(
          :influencer,
          :with_collection,
          first_name: 'Rene',
          last_name: 'Descartes'
        )
        user = create(:user)
        login(user)
        visit influencers_path
        fill_in "email or name", with: "Rene Descartes"
        click_on 'Search'

        expect_to_see influencer.first_name
        expect_to_see influencer.last_name
      end

      it "shows the influencer if the influencer's first name matches the query" do
        influencer = create(
          :influencer,
          :with_collection,
          first_name: 'Rene',
          last_name: 'Descartes'
        )
        user = create(:user)
        login(user)
        visit influencers_path
        fill_in "email or name", with: "Rene"
        click_on 'Search'

        expect_to_see influencer.first_name
        expect_to_see influencer.last_name
      end

      it "shows the influencer if the influencer's last name matches the query" do
        influencer = create(
          :influencer,
          :with_collection,
          first_name: 'Rene',
          last_name: 'Descartes'
        )
        user = create(:user)
        login(user)
        visit influencers_path
        fill_in "email or name", with: "Descartes"
        click_on 'Search'

        expect_to_see influencer.first_name
        expect_to_see influencer.last_name
      end

      it "shows the influencer if it's email matches the query" do
        influencer = create(
          :influencer,
          :with_collection,
          email: 'the_email@example.com'
        )
        user = create(:user)
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        fill_in 'email or name', with: "the_email@example.com"
        click_on 'Search'
        expect_to_see influencer.first_name
        expect_to_see influencer.address1
        expect_to_see influencer.state
      end

      it "does not show any influencers if none match the query" do
        influencer = create(
          :influencer,
          :with_collection,
          email: 'the_email@example.com',
          last_name: 'the_last_name'
        )
        user = create(:user)
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        fill_in 'email or name', with: "should_not_exist"
        click_on 'Search'
        expect_not_to_see influencer.first_name
        expect_not_to_see influencer.address1
        expect_not_to_see influencer.state
      end

      it "shows all the influencers if the query is empty" do
        influencer1 = create(
          :influencer,
          :with_collection
        )

        influencer2 = create(
          :influencer,
          :with_collection
        )

        influencer3 = create(
          :influencer,
          :with_collection
        )
        user = create(:user)
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        click_on 'Search'
        expect_to_see influencer1.first_name
        expect_to_see influencer1.address1
        expect_to_see influencer1.state

        expect_to_see influencer2.first_name
        expect_to_see influencer2.address1
        expect_to_see influencer2.state

        expect_to_see influencer3.first_name
        expect_to_see influencer3.address1
        expect_to_see influencer3.state
      end

      it "ignores whitespace in the query for an email" do
        influencer = create(
          :influencer,
          :with_collection,
          email: 'the_email@example.com'
        )
        user = create(:user)
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        fill_in 'email or name', with: "      the_email@example.com      "
        click_on 'Search'
        expect_to_see influencer.first_name
        expect_to_see influencer.address1
        expect_to_see influencer.state
      end

      it "ignores whitespace in the query for a last name" do
        influencer = create(
          :influencer,
          :with_collection,
          last_name: 'Descartes'
        )
        user = create(:user)
        login(user)
        within '#influencers_dropdown' do
          click_on 'Influencers'
        end
        click_on 'View Influencers'
        fill_in 'email or name', with: "        Descartes      "
        click_on 'Search'
        expect_to_see influencer.first_name
        expect_to_see influencer.address1
        expect_to_see influencer.state
      end
    end
  end
end
