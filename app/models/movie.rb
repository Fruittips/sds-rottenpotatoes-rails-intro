class Movie < ActiveRecord::Base

  def self.all_ratings
    @all_ratings = []
    self.all.each {|movie| 
      @all_ratings |= [movie[:rating]]}
    return @all_ratings
  end

  def self.with_ratings(ratings_list)
    if ratings_list.nil? || ratings_list.empty?
      return self.all
    else 
      return self.all.where(rating: ratings_list)
    end
  end

end
