class ProjectsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_project, only: [ :show, :update, :add_comment ]

  def index
    @projects = Project.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @project = current_user.projects.build
  end

  def create
    @project = current_user.projects.build(project_params)
    return render :new, status: :unprocessable_entity unless @project.save

    redirect_to @project, notice: "Project was successfully created."
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: "Project was successfully updated." }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(dom_id(@project),
            partial: "projects/project",
            locals: { project: @project }
          )
        }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(dom_id(@project),
            partial: "projects/project",
            locals: { project: @project }
          )
        }
      end
    end
  end

  def add_comment
    @comment = @project.add_comment(Current.user, comment_params[:content])

    respond_to do |format|
      if @comment.persisted?
        format.html { redirect_to @project, notice: "Comment was successfully added." }
        format.turbo_stream
      else
        format.html { render :show, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("new_comment",
            partial: "comments/form",
            locals: { project: @project, comment: @comment }
          )
        }
      end
    end
  end

  private

  def set_project
    @project = Project.includes(:user, :comments, :status_changes).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: "Project not found."
  end

  def project_params
    params.require(:project).permit(:title, :description, :status)
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
