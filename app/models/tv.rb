class Tv < ApplicationRecord
  self.primary_key = :tv_id
  has_many :tv_credits
  has_many :people, :through => :tv_credits
end
