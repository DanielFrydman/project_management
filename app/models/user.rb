class User < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :status_changes, dependent: :destroy
  has_secure_password

  validates :email, presence: true, 
                   uniqueness: { case_sensitive: false },
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }
  validates :name, presence: true

  before_validation do
    self.email = email.downcase if email.present?
    self.name = name.titleize if name.present?
  end
end
