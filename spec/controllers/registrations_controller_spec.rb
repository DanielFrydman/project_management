require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns a new user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            name: 'John Doe',
            email: 'john@example.com',
            password: 'password123'
          }
        }
      end

      it 'creates a new user' do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)
      end

      it 'sets the user_id in the session' do
        post :create, params: valid_params
        expect(session[:user_id]).to eq(User.last.id)
      end

      it 'redirects to projects path' do
        post :create, params: valid_params
        expect(response).to redirect_to(projects_path)
      end

      it 'sets a welcome flash message' do
        post :create, params: valid_params
        expect(flash[:notice]).to eq('Welcome! Your account has been created.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          user: {
            name: '',
            email: 'invalid-email',
            password: 'short'
          }
        }
      end

      it 'does not create a new user' do
        expect {
          post :create, params: invalid_params
        }.not_to change(User, :count)
      end

      it 'does not set the user_id in the session' do
        post :create, params: invalid_params
        expect(session[:user_id]).to be_nil
      end

      it 'renders the new template' do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
      end

      it 'returns unprocessable entity status' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'assigns the user with errors' do
        post :create, params: invalid_params
        expect(assigns(:user).errors).to be_present
      end
    end

    context 'with duplicate email' do
      let!(:existing_user) { create(:user, email: 'john@example.com') }
      let(:duplicate_params) do
        {
          user: {
            name: 'John Doe',
            email: 'john@example.com',
            password: 'password123'
          }
        }
      end

      it 'does not create a new user' do
        expect {
          post :create, params: duplicate_params
        }.not_to change(User, :count)
      end

      it 'renders the new template' do
        post :create, params: duplicate_params
        expect(response).to render_template(:new)
      end

      it 'returns unprocessable entity status' do
        post :create, params: duplicate_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'assigns the user with email uniqueness error' do
        post :create, params: duplicate_params
        expect(assigns(:user).errors[:email]).to include('has already been taken')
      end
    end
  end
end
