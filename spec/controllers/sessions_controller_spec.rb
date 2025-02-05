require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user, password: 'password123') }

    context 'with valid credentials' do
      let(:valid_params) { { email: user.email, password: 'password123' } }

      it 'sets the user_id in the session' do
        post :create, params: valid_params
        expect(session[:user_id]).to eq(user.id)
      end

      it 'redirects to projects path' do
        post :create, params: valid_params
        expect(response).to redirect_to(projects_path)
      end

      it 'sets a welcome flash message' do
        post :create, params: valid_params
        expect(flash[:notice]).to eq('Welcome back!')
      end
    end

    context 'with invalid credentials' do
      context 'with wrong password' do
        let(:invalid_params) { { email: user.email, password: 'wrongpassword' } }

        it 'does not set the user_id in the session' do
          post :create, params: invalid_params
          expect(session[:user_id]).to be_nil
        end

        it 'renders the new template' do
          post :create, params: invalid_params
          expect(response).to render_template(:new)
        end

        it 'sets an error flash message' do
          post :create, params: invalid_params
          expect(flash.now[:alert]).to eq('Invalid email or password')
        end

        it 'returns unprocessable entity status' do
          post :create, params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'with non-existent email' do
        let(:invalid_params) { { email: 'nonexistent@example.com', password: 'password123' } }

        it 'does not set the user_id in the session' do
          post :create, params: invalid_params
          expect(session[:user_id]).to be_nil
        end

        it 'renders the new template' do
          post :create, params: invalid_params
          expect(response).to render_template(:new)
        end

        it 'sets an error flash message' do
          post :create, params: invalid_params
          expect(flash.now[:alert]).to eq('Invalid email or password')
        end

        it 'returns unprocessable entity status' do
          post :create, params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'with blank credentials' do
        let(:invalid_params) { { email: '', password: '' } }

        it 'does not set the user_id in the session' do
          post :create, params: invalid_params
          expect(session[:user_id]).to be_nil
        end

        it 'renders the new template' do
          post :create, params: invalid_params
          expect(response).to render_template(:new)
        end

        it 'sets an error flash message' do
          post :create, params: invalid_params
          expect(flash.now[:alert]).to eq('Invalid email or password')
        end

        it 'returns unprocessable entity status' do
          post :create, params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    before do
      session[:user_id] = user.id
    end

    it 'removes the user_id from the session' do
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to login path' do
      delete :destroy
      expect(response).to redirect_to(login_path)
    end

    it 'sets a logout flash message' do
      delete :destroy
      expect(flash[:notice]).to eq('You have been logged out.')
    end
  end
end
