require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'associations' do
    it { should belong_to :question }
  end
  describe 'validations' do
    let(:question) { create(:question) }
    it { should validate_presence_of :name }
    it { should validate_presence_of :file }
    it 'validates format of file' do
      reward = Reward.new(question: question, name: 'test', file: Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb"))
      reward.save
      expect(reward).to be_invalid
      expect(reward.errors[:file]).to include("Must be a JPG, GIF or PNG file")
    end
  end
end
