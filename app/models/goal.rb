class Goal < ApplicationRecord
  validates :name, :time_beg, :time_limit, presence: tru
  belongs_to :recommendation
end
