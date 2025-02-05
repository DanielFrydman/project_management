module ProjectStateTracking
  extend ActiveSupport::Concern

  included do
    before_validation :handle_status_change, if: :will_save_change_to_status?
    validate :validate_status_change, if: :status_changed?
  end

  def add_comment(user, content)
    comments.create(user: user, content: content)
  end

  private

  def handle_status_change
    return unless persisted?

    status_changes.build(
      user: Current.user,
      old_status: status_was,
      new_status: status
    )
  end

  def validate_status_change
    return unless persisted?
    return if status_was.nil? # Skip for new records

    if status.to_s == status_was.to_s
      errors.add(:status, "can't be changed to the same status")
    end
  end

  def add_error_and_throw_abort(message)
    errors.add(:status, message)
    throw(:abort)
  end
end
