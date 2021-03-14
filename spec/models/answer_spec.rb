require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
  end
  describe 'validations' do
    let(:question) { create(:question) }
    let!(:answer_best) { create(:answer, question: question, best: true) }
    let(:answer) { create(:answer, question: question) }

    it { should validate_presence_of(:body) }

    it 'validates number of best answers to be 1' do
      answer.best = true
      answer.save
      expect(answer).to be_invalid
      expect(answer.errors[:best]).to include("Can't mark multiple answers")
    end
  end
  describe 'methods' do
    describe 'mark_as_best' do
      let(:question) { create(:question) }
      let!(:answer_best) { create(:answer, question: question, best: true) }
      let(:answer) { create(:answer, question: question) }

      it 'updates answers' do
        answer.mark_as_best
        answer.reload
        answer_best.reload
        expect(answer.best).to be true
        expect(answer_best.best).to be false
      end
    end
  end
end
