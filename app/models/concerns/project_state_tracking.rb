module ProjectStateTracking
  extend ActiveSupport::Concern

  included do
    before_validation :handle_status_change, if: :will_save_change_to_status?
  end

  def add_comment(user, content)
    comments.create(user: user, content: content)
  end

  private

  def handle_status_change
    return unless persisted?
    
    return add_error_and_throw_abort("can't be changed to the same status") if status == status_was

    status_changes.build(
      user: Current.user,
      old_status: status_was,
      new_status: status
    )
  end

  def add_error_and_throw_abort(message)
    errors.add(:status, message)
    throw(:abort)
  end
end 