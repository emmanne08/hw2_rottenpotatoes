class Movie < ActiveRecord::Base
  def self.all_ratings
    self.select("DISTINCT(rating)").map { |x| x.rating }.sort
  end
end
