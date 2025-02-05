class CommentsComponent < ViewComponent::Base
  include Turbo::FramesHelper
  include ActionView::Helpers::FormHelper

  def initialize(project:, comment: nil)
    @project = project
    @comment = comment
  end

  private

  attr_reader :project, :comment
end
