require 'rails_helper'

RSpec.describe CreatedAnswersJob, type: :job do
  let(:answer) { create(:answer) }
  let(:service) { double('CreatedAnswersService') }

  before do
    allow(CreatedAnswersService).to receive(:new).and_return(service)
  end

  it 'calls CreatedAnswersService#call' do
    expect(service).to receive(:call).with(answer)
    CreatedAnswersJob.perform_now(answer)
  end
end
