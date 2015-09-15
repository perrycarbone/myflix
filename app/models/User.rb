class User < ActiveRecord::Base
  has_secure_password validations: false
  validates :full_name, presence: true
  validates :email_address, presence: true
  validates :password, presence: true, on: :create, length: {minimum: 5}
end
