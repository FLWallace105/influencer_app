require 'active_record'
require '/home/dev_team/influencers/app/models/product'
require '/home/dev_team/influencers/app/models/product_variant'
require '/home/dev_team/influencers/app/models/collect'
require '/home/dev_team/influencers/app/models/custom_collection'


ActiveRecord::Base.establish_connection(
  adapter:  "postgresql",
  host:     "take_from_rails_credential",
  username: "take_from_rails_credential",
  password: "take_from_rails_credential",
  database: "take_from_rails_credential"
)

RSpec.describe "ShopifyCache" do
  describe 'verify correct number of shopify resources' do
    it 'verifies correct number of products' do
      
      my_product_num = Product.all.count
      expect(my_product_num).to eq(4046)
    end
    it 'verifies correct number of variants' do
      
        my_variant_num = ProductVariant.all.count
        expect(my_variant_num).to eq(12742)
    end
    it 'verifies correct number of collects' do
      
        my_collect_num = Collect.all.count
        expect(my_collect_num).to eq(7954)
    end
    it 'verifies correct number of custom collections' do
      
        my_custom_collect_num = CustomCollection.all.count
        expect(my_custom_collect_num).to eq(941)
    end
  end
end
