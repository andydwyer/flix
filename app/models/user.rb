class User < ApplicationRecord
  before_save :format_username

  has_secure_password
  has_many :reviews, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :favourite_movies, through: :favourites, source: :movie

  validates :name, :username, presence: true
  validates :email, format: { with: /\S+@\S+/ }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6, allow_blank: true }
  validates :username, format: { with: /\A[A-Z0-9]+\z/i }, uniqueness: { case_sensitive: false }

  scope :by_name, -> { order("name") }
  scope :not_admins, -> { by_name.where(admin: false) }

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

private

  def format_username
    self.username = username.downcase
  end

end
