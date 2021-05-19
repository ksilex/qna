require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].last }
      let!(:answers) { create_list(:answer, 2, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns user' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      context 'associated answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns question answers' do
          expect(question_response['answers'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, :with_file, :with_link) }
    let!(:comment) { create(:comment, parent: question) }
    let!(:answer) { create(:answer, question: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns question' do
        expect(question_response['id']).to eq question.id
      end

      it 'returns user' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'returns answers' do
        expect(question_response['answers'].first['id']).to eq question.answers.first.id
      end

      it 'returns links' do
        expect(question_response['links'].first['id']).to eq question.links.first.id
      end

      it 'returns files' do
        expect(question_response['files'].first['id']).to eq question.files.first.id
      end

      it 'returns comments' do
        expect(question_response['comments'].first['id']).to eq question.comments.first.id
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { post api_path, params: { title: 'title', body: 'body', access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns created question' do
        expect(json['question']['title']).to eq 'title'
        expect(json['question']['body']).to eq 'body'
      end
    end
  end

  describe 'DELETE /api/v1/questions' do
    let(:access_token) { create(:access_token) }
    let(:access_token_other) { create(:access_token) }
    let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized as author' do
      it 'destroys question' do
        expect { delete api_path, params: { access_token: access_token.token }, headers: headers }.to change(Question, :count).by(-1)
        expect(response.status).to eq 204
      end
    end

    context 'authorized as user' do
      it 'returns 403' do
        expect { delete api_path, params: { access_token: access_token_other.token }, headers: headers }.to_not change(Question, :count)
        expect(response.status).to eq 403
      end
    end
  end

  describe 'UPDATE /api/v1/questions/:id' do
    let(:access_token) { create(:access_token) }
    let(:access_token_other) { create(:access_token) }
    let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end

    context 'authorized as author' do
      before do
        put api_path, params: { id: question.id, title: 'edited title', access_token: access_token.token }, headers: headers
        question.reload
      end
      it 'updates question' do
        expect(question.title).to eq 'edited title'
      end

      it 'returns updated question' do
        expect(json['question']['title']).to eq 'edited title'
      end
    end

    context 'authorized as user' do
      it 'returns 403' do
        expect do
          put api_path, params:  { id: question.id, title: 'edited title', access_token: access_token_other.token },
                        headers: headers
        end.to_not change(question, :title)
        expect(response.status).to eq 403
      end
    end
  end
end
