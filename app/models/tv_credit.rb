class TvCredit < ApplicationRecord
  self.primary_key = :tv_credit_id
  belongs_to :tv
  belongs_to :person
end
