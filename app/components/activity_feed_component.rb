class ActivityFeedComponent < ViewComponent::Base
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
      tag.span(class: "text-gray-700") do
        safe_join([
          "Changed status from  ",
          tag.span(activity.old_status.humanize, class: status_color_classes(activity.old_status, 'p-2 rounded-lg')),
          "  to  ",
          tag.span(activity.new_status.humanize, class: status_color_classes(activity.new_status, 'p-2 rounded-lg'))
        ])
      end
    end
  end
end 