class Project < ApplicationRecord
  include ProjectStateTracking

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :status_changes, dependent: :destroy

  enum :status, {
    not_started: 0,
    in_progress: 1,
    on_hold: 2,
    completed: 3
  }, default: :not_started

  validates :title, presence: true
  validates :status, presence: true
end
