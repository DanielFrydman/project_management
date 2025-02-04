class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :update, :add_comment]

  def show
  end

  def update
    if @project.update(project_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @project }
      end
    else
      render :show, status: :unprocessable_entity
    end
  end

  def add_comment
    if @project.add_comment(Current.user, comment_params[:content])
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @project }
      end
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.last
  end

  def project_params
    params.require(:project).permit(:title, :description, :status)
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end 