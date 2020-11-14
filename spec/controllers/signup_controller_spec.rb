require "rails_helper"

RSpec.describe SignupController, type: :controller do

  describe 'POST #create' do
    let(:password) { 'password' }
    let(:password_confirmation) { 'password' }
    let(:email) { 'bboymoroz@mail.ru' }
    let(:user_params) { { email: email, password: password, password_confirmation: password_confirmation } }

    it 'returns http success' do
      post :create, params: user_params
      expect(response).to be_successful
    end

  end
end