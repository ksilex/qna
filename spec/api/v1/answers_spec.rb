require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) {  { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 2, question: question) }
    let(:answer) { answers.first }
    let(:api_path) { "/api/v1/questions/#{answer.question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answers'].first }
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { id: answer.question.id, access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id user_id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer, :with_file, :with_link) }
    let!(:comment) { create(:comment, parent: answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns answer' do
        expect(answer_response['id']).to eq answer.id
      end

      it 'returns user' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end

      it 'returns links' do
        expect(answer_response['links'].first['id']).to eq answer.links.first.id
      end

      it 'returns files' do
        expect(answer_response['files'].first['id']).to eq answer.files.first.id
      end

      it 'returns comments' do
        expect(answer_response['comments'].first['id']).to eq answer.comments.first.id
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { post api_path, params: {question_id: question.id, body: 'body', access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns created answer' do
        expect(json['answer']['body']).to eq 'body'
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:access_token) { create(:access_token) }
    let(:access_token_other) { create(:access_token) }
    let!(:answer) { create(:answer, user_id: access_token.resource_owner_id) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized as author' do
      it 'destroys answer' do
        expect { delete api_path, params: { access_token: access_token.token }, headers: headers }.to change(Answer, :count).by(-1)
        expect(response.status).to eq 204
      end
    end

    context 'authorized as user' do
      it 'returns 403' do
        expect { delete api_path, params: { access_token: access_token_other.token }, headers: headers }.to_not change(Answer, :count)
        expect(response.status).to eq 403
      end
    end
  end

  describe 'UPDATE /api/v1/answers/:id' do
    let(:access_token) { create(:access_token) }
    let(:access_token_other) { create(:access_token) }
    let!(:answer) { create(:answer, user_id: access_token.resource_owner_id) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end

    context 'authorized as author' do
      before do
        put api_path, params: { id: answer.id, body: 'edited body', access_token: access_token.token }, headers: headers
        answer.reload
      end
      it 'updates answer' do
        expect(answer.body).to eq 'edited body'
      end

      it 'returns updated answer' do
        expect(json['answer']['body']).to eq 'edited body'
      end
    end

    context 'authorized as user' do
      it 'returns 403' do
        expect { put api_path, params: { id: answer.id, body: 'edited body', access_token: access_token_other.token },
                               headers: headers
                }.to_not change(answer, :body)
        expect(response.status).to eq 403
      end
    end
  end
end
