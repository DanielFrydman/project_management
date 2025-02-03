class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :status_changes, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
