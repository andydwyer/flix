module MoviesHelper

    def total_gross(movie)
        if movie.upcoming?
            "Coming Soon"
        elsif movie.flop?
            "Flop!"
        else
            number_to_currency(movie.total_gross, precision: 0)
        end
    end

    def year_of(movie)
        movie.released_on.year
    end

    def main_image(movie)
        if movie.main_image.attached?
            image_tag movie.main_image.variant(resize_to_limit: [150, nil])
        else
            image_tag("placeholder.png")
        end
    end
    
end
