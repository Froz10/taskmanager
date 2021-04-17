require "rails_helper"

RSpec.describe Api::V1::ProjectsController, type: :controller do
  let(:user) { create(:user) }

  let(:valid_attributes) {
    { title: 'new title' }
  }

  let(:invalid_attributes) {
    { title: nil }
  }

  before { sign_in_as(user) }

  describe 'GET #index' do
    let!(:project) { create(:project, user: user) }

    it 'returns a success response' do
      get :index
      expect(response).to be_successful
      expect(response_json.size).to eq 1
      expect(response_json.first['id']).to eq project.id
    end
    
    it 'unauth without cookie' do
      request.cookies[JWTSessions.access_cookie] = nil
      get :index
      expect(response).to have_http_status(401)
    end
  end
end