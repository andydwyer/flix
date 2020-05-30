class Movie < ApplicationRecord
    before_save :set_slug

    has_many :reviews, -> { order("created_at desc") }, dependent: :destroy
    has_many :critics, through: :reviews, source: :user
    has_many :favourites, dependent: :destroy
    has_many :fans, through: :favourites, source: :user
    has_many :characterizations, dependent: :destroy
    has_many :genres, through: :characterizations

    has_one_attached :main_image

    FLOP_THRESHOLD = 170000000
    RATINGS = %w(G PG PG-13 R NC-17)

    validates :released_on, :duration, :director, presence: true
    validates :description, length: { minimum: 25 }
    validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
    validates :rating, inclusion: { in: RATINGS }
    validates :title, presence: true, uniqueness: true
    validate :acceptable_image

    scope :released_movies, -> { where("released_on <= ?", Time.now).order("released_on desc") }
    scope :upcoming, -> { where("released_on > ?", Time.now).order("released_on asc") }
    scope :recent, -> (max=5) { released_movies.limit(max)}
    scope :hit_movies, -> { released_movies.where("total_gross >= ?", 300000000).order("total_gross desc") }
    scope :flop_movies, -> { released_movies.where("total_gross < ?", FLOP_THRESHOLD).order("total_gross asc") }
    scope :recently_added_movies, -> (max=3) { order("created_at desc").limit(max) }
    scope :grossed_less_than, -> (amount=1000000) { released_movies.where("total_gross < ?", amount) }
    scope :grossed_greater_than, -> (amount=1000000) { releasaed_movies.where("total_gross > ?", amount) }
    
    def flop?
        (total_gross.blank? || total_gross.zero? || total_gross < FLOP_THRESHOLD) && !cult_classic?
    end

    def upcoming?
        released_on > Time.now
    end

    def cult_classic?
        reviews.count > 50 && reviews.average(:stars) >= 4
    end

    def average_stars
        reviews.average(:stars) || 0.0
    end

    def average_stars_as_percent
        (self.average_stars / 5.0) * 100
    end

    def to_param
        slug
    end

private

    def set_slug
        self.slug = title.parameterize
    end

    def acceptable_image
        return unless main_image.attached?
      
        unless main_image.blob.byte_size <= 1.megabyte
          errors.add(:main_image, "is too big")
        end
      
        acceptable_types = ["image/jpeg", "image/png"]
        unless acceptable_types.include?(main_image.content_type)
          errors.add(:main_image, "must be a JPEG or PNG")
        end
    end

end
