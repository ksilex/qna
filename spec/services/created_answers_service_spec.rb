require 'rails_helper'
RSpec.describe DailyDigestService do
  let!(:answer) { create(:answer) }
  let(:subscriber_1) { create(:user, subscriptions: [Subscription.new(question: answer.question)]) }#пришлось так писать, create_list себя непредсказуемо вел
  let(:subscriber_2) { create(:user, subscriptions: [Subscription.new(question: answer.question)]) }
  let(:not_subed_users) { create_list(:user, 5) }

  it 'sends new answer to subscribed users' do
    subscriber_1
    subscriber_2
    answer.question.subscribers.each do |user|
      expect(NewAnswerMailer).to receive(:send_answer).with(user, answer).and_call_original
    end
    CreatedAnswersJob.perform_now(answer)
  end

  it 'sends new answer to author of question' do
    expect(NewAnswerMailer).to receive(:send_answer).with(answer.question.user, answer).and_call_original
    CreatedAnswersJob.perform_now(answer)
  end

  it 'does not send new answer to author of answer' do
    expect(NewAnswerMailer).to_not receive(:send_answer).with(answer.user, answer).and_call_original
  end

  it 'does not send new answer to non-subed users' do
    not_subed_users.each do |user|
      expect(NewAnswerMailer).to_not receive(:send_answer).with(user, answer).and_call_original
    end
  end
end
