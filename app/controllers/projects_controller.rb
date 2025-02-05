class ProjectsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_project, only: [:show, :update, :add_comment]

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

    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
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
        format.turbo_stream
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :status)
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end 