require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    it { should belong_to :parent }
    it { should belong_to :user }
  end
  describe 'validations' do
    it { should define_enum_for(:vote_type).with(Vote.vote_types.keys) }
    it { should validate_presence_of :vote_type }
  end
end
