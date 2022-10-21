class Movie < ActiveRecord::Base
  def self.find_same_director_movies(id)
    target_director = Movie.find(id).director
    if target_director.nil? or target_director.blank?
      return nil
    else
      return Movie.where(director: target_director)
    end
  end
end
