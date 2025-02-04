module StatusColorable
  extend ActiveSupport::Concern

  def status_color_classes(status = nil, additional_classes = '')
    status ||= @project.status if defined?(@project)
    base_classes = case status.to_s
    when 'not_started'
      'bg-zinc-300 text-gray-800'
    when 'in_progress'
      'bg-blue-100 text-blue-800'
    when 'on_hold'
      'bg-yellow-100 text-yellow-800'
    when 'completed'
      'bg-green-100 text-green-800'
    end

    [base_classes, additional_classes].join(' ').strip
  end
end 