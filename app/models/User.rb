class User < ActiveRecord::Base
  has_many :queue_items, -> { order 'position' }
  has_secure_password validations: false

  validates :full_name, presence: true
  validates :email_address, presence: true
  validates :password, presence: true, on: :create, length: {minimum: 5}
  validates_uniqueness_of :email_address
end
