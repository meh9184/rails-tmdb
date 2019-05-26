class Movie < ApplicationRecord
  self.primary_key = :movie_id
  has_many :movie_credits
  has_many :people, :through => :movie_credits
end
