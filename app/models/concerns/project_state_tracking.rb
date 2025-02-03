module ProjectStateTracking
  extend ActiveSupport::Concern

  included do
    before_validation :handle_status_change
  end

  def add_comment(user, content)
    comments.create!(user: user, content: content)
  end

  private

  def track_status_change(old_status, new_status)
    status_changes.create!(
      user: Current.user,
      old_status: old_status,
      new_status: new_status
    )
  end

  def handle_status_change
    return track_status_change(status_was, status) if status_was != status

    errors.add(:status, "can't be changed to the same status")
  end
end 