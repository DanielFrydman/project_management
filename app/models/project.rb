class Project < ApplicationRecord
  enum :status, {
    not_started: 0,
    in_progress: 1,
    on_hold: 2,
    completed: 3
  }, default: :not_started

  validates :name, presence: true
  validates :status, presence: true
end
