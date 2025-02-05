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
    if project_params[:status] && !Project.statuses.key?(project_params[:status])
      @project.errors.add(:status, "is not a valid status")
      return respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@project), partial: "projects/project", locals: { project: @project }) }
        format.html { render :show, status: :unprocessable_entity }
      end
    end

    return respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @project }
    end if @project.update(project_params)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@project), partial: "projects/project", locals: { project: @project }) }
      format.html { render :show, status: :unprocessable_entity }
    end
  end

  def add_comment
    @comment = @project.add_comment(Current.user, comment_params[:content])

    return respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @project }
    end if @comment.persisted?

    respond_to do |format|
      format.turbo_stream
      format.html { render :show, status: :unprocessable_entity }
    end
  end

  private

  def set_project
    @project = Project.includes(:user, :comments, :status_changes).find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description, :status)
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
