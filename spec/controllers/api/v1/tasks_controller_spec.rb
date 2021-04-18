require "rails_helper"

RSpec.describe Api::V1::TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project) }

  let(:valid_attributes) {
    { name: 'new name',
      priority: 'new priority', 
      status: 'new status', 
      deadline: '31.12.2021', 
      project_id: project.id }
  }

  let(:invalid_attributes) {
    { name: nil,
      priority: nil, 
      status: nil, 
      deadline: nil, 
      project_id: nil }
  }

  before { sign_in_as(user) }

  describe 'GET #index' do
    let!(:task) { create(:task, user: user, project_id: project.id) }

    it 'returns a success response' do
      get :index
      expect(response).to be_successful
      expect(response_json.size).to eq 1
      expect(response_json.first['id']).to eq task.id
    end

    it 'unauth without cookie' do
      request.cookies[JWTSessions.access_cookie] = nil
      get :index
      expect(response).to have_http_status(401)
    end
  end

  describe 'GET #show' do
    let!(:task) { create(:task, user: user, project_id: project.id) }
    before { sign_in_as(user) }

    it 'returns a success response' do
      get :show, params: { id: task.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do

    context 'with valid params' do
      it 'creates a new Task' do
        expect {
          post :create, params: { task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it 'renders a JSON response with the new Task' do
        post :create, params: { task: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end

      it 'unauth without CSRF' do
        request.headers[JWTSessions.csrf_header] = nil
        post :create, params: { task: valid_attributes }
        expect(response).to have_http_status(401)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new todo' do
        post :create, params: { task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe 'PUT #update' do
    let!(:task) { create(:task, user: user, project_id: project.id) }

    context 'with valid params' do
      let(:new_attributes) {
        { name: 'new name',
          priority: 'new priority', 
          status: 'new status' }
      }

      it 'updates the requested task' do
        put :update, params: { id: task.id, task: new_attributes }
        task.reload
        expect(task.name).to eq new_attributes[:name]
        expect(task.priority).to eq new_attributes[:priority]
        expect(task.status).to eq new_attributes[:status]
      end

      it 'renders a JSON response with the task' do
        put :update, params: { id: task.to_param, task: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the task' do
        put :update, params: { id: task.to_param, task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:task) { create(:task, user: user, project_id: project.id) }

    it 'destroys the requested todo' do
      expect {
        delete :destroy, params: { id: task.id }
      }.to change(Task, :count).by(-1)
    end
  end
end
