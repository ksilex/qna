require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:answer_comment) { create(:comment, parent: answer) }
  let(:question_comment) { create(:comment, parent: question) }
  describe 'POST #create' do
    before { login(user) }
    context 'answer comment' do
      before { answer_comment }

      it 'saves a new comment in the database' do
        expect { post :create, params: { comment: { parent: answer_comment.parent,
                                                    user_id: answer_comment.user.id,
                                                    body: answer_comment.body },
                                        format: :js,
                                        answer_id: answer_comment.parent.id
                                        }
                }.to change(answer.comments, :count).by(1)
      end
    end
    context 'question comment' do
      before { question_comment }

      it 'saves a new comment in the database' do
        expect { post :create, params: { comment: { parent: question_comment.parent,
                                                    user_id: question_comment.user.id,
                                                    body: question_comment.body },
                                        format: :js,
                                        question_id: question_comment.parent.id
                                        }
                }.to change(question.comments, :count).by(1)
      end
    end
  end
end
