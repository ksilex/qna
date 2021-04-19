require 'rails_helper'
RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 5) }
  it 'sends daily digest to users' do
    users.each do |user|
      expect(DailyDigestMailer).to receive(:send_digest).with(user).and_call_original
    end
    subject.call
  end
end
