class User < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :email, :password
  validates_length_of :first_name, :last_name, minimum: 3
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_length_of :password, minimum: 8

  before_save :hash_password

  private

  def hash_password
    self.password = BCrypt::Password.create(password)
  end
end
