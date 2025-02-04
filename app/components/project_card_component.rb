class ProjectCardComponent < ViewComponent::Base
  include Turbo::FramesHelper
  include ActionView::Helpers::FormHelper
  include StatusColorable

  def initialize(project:)
    @project = project
  end

  def status_options
    Project.statuses.map do |status, _value|
      [status.titleize, status]
    end
  end

  private

  attr_reader :project
end 