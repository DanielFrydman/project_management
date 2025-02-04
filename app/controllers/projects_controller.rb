class ProjectsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_project, only: [:show, :update, :add_comment]

  def show
  end

  def update
    if Project.statuses.key?(project_params[:status])
      if @project.update(project_params)
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to @project }
        end
      else
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@project), partial: "projects/project", locals: { project: @project }) }
          format.html { render :show, status: :unprocessable_entity }
        end
      end
    else
      @project.errors.add(:status, "is not a valid status")
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@project), partial: "projects/project", locals: { project: @project }) }
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  def add_comment
    @comment = @project.add_comment(Current.user, comment_params[:content])
    
    if @comment.persisted?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @project }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("project_comments", partial: "projects/comments", locals: { project: @project, comment: @comment }) }
        format.html { render :show, status: :unprocessable_entity }
      end
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