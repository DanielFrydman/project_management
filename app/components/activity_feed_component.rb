class ActivityFeedComponent < ViewComponent::Base
  include Turbo::FramesHelper
  include StatusColorable

  def initialize(project:)
    @project = project
    @activities = (project.comments + project.status_changes).sort_by(&:created_at).reverse
  end

  private

  attr_reader :project, :activities

  def activity_content(activity)
    if activity.is_a?(Comment)
      activity.content
    else
      tag.span do
        safe_join([
          "Changed status from ",
          tag.span(activity.old_status.humanize, class: status_color_classes(activity.old_status, 'rounded-lg'), style: 'padding: 0.20rem 0.25rem;'),
          " to ",
          tag.span(activity.new_status.humanize, class: status_color_classes(activity.new_status, 'rounded-lg'), style: 'padding: 0.20rem 0.25rem;')
        ])
      end
    end
  end
end 