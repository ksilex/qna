require 'rails_helper'
require 'cancan/matchers'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }

    let(:question) { create(:question, :with_file, user: user) }
    let(:question_other) { create(:question, :with_file, user: other) }

    let(:answer) { create(:answer, :with_file, question: question, user: user) }
    let(:answer_other) { create(:answer, :with_file, question: question_other, user: other) }

    let(:comment) { create(:comment, parent: question, user: user) }
    let(:comment_other) { create(:comment, parent: question, user: other) }

    let(:link) { create(:link, parent: question) }
    let(:link_other) { create(:link, parent: question_other) }

    it { should_not be_able_to :manage, :all }

    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :edit, question }
    it { should be_able_to :edit, answer }
    it { should_not be_able_to :edit, question_other }
    it { should_not be_able_to :edit, answer_other }

    it { should be_able_to :update, question }
    it { should be_able_to :update, answer }
    it { should be_able_to :update, comment }
    it { should_not be_able_to :update, question_other }
    it { should_not be_able_to :update, answer_other }
    it { should_not be_able_to :update, comment_other }

    it { should be_able_to :destroy, question }
    it { should be_able_to :destroy, answer }
    it { should be_able_to :destroy, link }
    it { should be_able_to :destroy, question.files.last }
    it { should_not be_able_to :destroy, question_other }
    it { should_not be_able_to :destroy, answer_other }
    it { should_not be_able_to :destroy, link_other }
    it { should_not be_able_to :destroy, question_other.files.last }

    it { should be_able_to [:upvote, :downvote], question_other }
    it { should be_able_to [:upvote, :downvote], answer_other }
    it { should be_able_to :unvote, question_other }
    it { should be_able_to :unvote, answer_other }
    it { should_not be_able_to [:upvote, :downvote], question }
    it { should_not be_able_to [:upvote, :downvote], answer }

    it { should be_able_to :best, answer }
    it { should_not be_able_to :best, answer_other }
  end
end
