class ReviewsController < ApplicationController
    
    before_action :set_movie
    before_action :require_signin
    
    def index
        @reviews = @movie.reviews
    end

    def new
        @review = @movie.reviews.new
    end

    def create
        @review = @movie.reviews.new(review_params)
        @review.user = current_user
        if @review.save
            redirect_to movie_reviews_url(@movie), notice: "Thanks for your review!"
        else
            render :new
        end
    end

    private

    def review_params
        params.require(:review).permit(:stars, :comment)
    end

    def set_movie
        @movie = Movie.find_by!(slug: params[:movie_id])
    end

end
