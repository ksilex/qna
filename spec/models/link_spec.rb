require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'associations' do
    it { should belong_to :parent }
  end
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }
    it { should allow_value('https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c').for(:url) }
    it { should_not allow_value("test.com").for(:url) }
  end
end
