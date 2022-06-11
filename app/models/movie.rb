class Movie < ActiveRecord::Base

  # def initialize
  #   @all_ratings = ['G','PG','PG-13','R']
  # end

  def all_ratings
    @all_ratings
  end

  def self.with_ratings(ratings_list)
    if ratings_list.nil? || ratings_list.empty?
      return self.all
    else 
      return self.all.where(rating: ratings_list)
    end
  end

end
