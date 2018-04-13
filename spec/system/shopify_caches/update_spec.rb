require 'rails_helper'
# TODO:: this will remain broken until someone figures out how to get Resque to
# run inline for tests, or we switch to using Sidekiq which I know how to run inline
RSpec.describe "ShopifyCaches" do
  context 'when a user is signed in' do
    describe 'successfully refreshes the entire shopify cache' do
      it 'updates: Collect, CustomCollection, Product, ProductVariant', :js, :broken do
        user = create(:user)
        login(user)
        click_on 'Danger Zone'
        click_on 'Refresh Everything'

        expect(Product.count).to eq(ShopifyAPI::Product.count)
        expect(CustomCollection.count).to eq(ShopifyAPI::CustomCollection.count)
        expect(Collect.count).to eq(ShopifyAPI::Collect.count)
        expect_to_see 'Refreshing entire Shopify Cache. Please wait a couple mintues...'
      end
    end
  end
end
