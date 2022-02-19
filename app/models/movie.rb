class Movie < ActiveRecord::Base
    def self.ratings
        return Movie.select(:rating).distinct.inject([]) { |a, m| a.push m.rating }
    end
end
