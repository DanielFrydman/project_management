require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:valid_attributes) { { title: "Test Project", description: "Test Description" } }
  let(:invalid_attributes) { { title: "", description: "Test Description" } }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(Current).to receive(:user).and_return(user)
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: project.id }
      expect(response).to be_successful
    end

    it "redirects to projects_path when project not found" do
      get :show, params: { id: 'invalid' }
      expect(response).to redirect_to(projects_path)
      expect(flash[:alert]).to eq("Project not found.")
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Project" do
        expect {
          post :create, params: { project: valid_attributes }
        }.to change(Project, :count).by(1)
      end

      it "redirects to the created project" do
        post :create, params: { project: valid_attributes }
        expect(response).to redirect_to(Project.last)
      end
    end

    context "with invalid params" do
      it "returns unprocessable_entity status" do
        post :create, params: { project: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      let(:new_attributes) { { title: "Updated Title" } }

      it "updates the requested project" do
        patch :update, params: { id: project.id, project: new_attributes }
        project.reload
        expect(project.title).to eq("Updated Title")
      end

      it "redirects to the project" do
        patch :update, params: { id: project.id, project: valid_attributes }
        expect(response).to redirect_to(project)
      end
    end

    context "with invalid params" do
      it "returns unprocessable_entity status" do
        patch :update, params: { id: project.id, project: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST #add_comment" do
    let(:valid_comment_params) { { content: "Test comment" } }
    let(:invalid_comment_params) { { content: "" } }

    context "with valid params" do
      it "creates a new comment" do
        expect {
          post :add_comment, params: { id: project.id, comment: valid_comment_params }
        }.to change(Comment, :count).by(1)
      end

      it "redirects to the project" do
        post :add_comment, params: { id: project.id, comment: valid_comment_params }
        expect(response).to redirect_to(project)
      end
    end

    context "with invalid params" do
      it "returns unprocessable_entity status" do
        post :add_comment, params: { id: project.id, comment: invalid_comment_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
