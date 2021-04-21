require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.find' do
    context 'with no search params provided' do
      it "returns nothing" do
        expect(Search.find()).to eq nil
      end
    end

    context 'with params' do
      Search::RESOURCES.each do |resource|
        it "performs search" do
          expect(Search).to receive(:find).with({ query: "test", indices: [resource] })
          Search.find(query: "test", indices: [resource])
        end
      end
    end
  end
end
