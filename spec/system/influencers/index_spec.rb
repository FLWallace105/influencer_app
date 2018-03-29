require 'rails_helper'

RSpec.describe "Influencers Index" do
  context 'when no influencers exist' do
    describe 'visit the influencers index page' do
      it 'does not show any influencers' do
        visit root_path
      end
    end
  end
end
