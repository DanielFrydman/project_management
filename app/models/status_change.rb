class StatusChange < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :old_status, presence: true, inclusion: { in: ->(_) { Project.statuses.keys } }
  validates :new_status, presence: true, inclusion: { in: ->(_) { Project.statuses.keys } }
  validates :new_status, comparison: { other_than: :old_status, message: "can't be the same as the old status" }
end
