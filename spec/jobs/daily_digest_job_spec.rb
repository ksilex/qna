require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double('Service::DailyDigest') }

  before do
    allow(DailyDigestService).to receive(:new).and_return(service)
  end

  it 'calls DailyDigestService#call' do
    expect(service).to receive(:call)
    DailyDigestJob.perform_now
  end
end
