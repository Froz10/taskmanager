require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do
  let(:user) { create(:user) }

  let(:valid_attributes) {
    { name: 'new name' }
  }

  let(:invalid_attributes) {
    { name: nil }
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

  describe 'GET #show' do
    let!(:project) { create(:project, user: user) }
    before { sign_in_as(user) }

    it 'returns a success response' do
      get :show, params: { id: project.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do

    context 'with valid params' do
      it 'creates a new project' do
        expect {
          post :create, params: { project: valid_attributes }
        }.to change(Project, :count).by(1)
      end

      it 'renders a JSON response with the new Project' do
        post :create, params: { project: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end

      it 'unauth without CSRF' do
        request.headers[JWTSessions.csrf_header] = nil
        post :create, params: { project: valid_attributes }
        expect(response).to have_http_status(401)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new Project' do
        post :create, params: { project: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe 'PUT #update' do
    let!(:project) { create(:project, user: user) }

    context 'with valid params' do
      let(:new_attributes) {
        { name: 'Super secret title' }
      }

      it 'updates the requested Project' do
        put :update, params: { id: project.id, project: new_attributes }
        project.reload
        expect(project.name).to eq new_attributes[:name]
      end

      it 'renders a JSON response with the Project' do
        put :update, params: { id: project.to_param, project: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the Project' do
        put :update, params: { id: project.to_param, project: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:project) { create(:project, user: user) }

    it 'destroys the requested Project' do
      expect {
        delete :destroy, params: { id: project.id }
      }.to change(Project, :count).by(-1)
    end
  end
end