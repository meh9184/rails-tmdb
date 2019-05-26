class MovieCredit < ApplicationRecord
  self.primary_key = :movie_credit_id
  belongs_to :movie
  belongs_to :person
end
