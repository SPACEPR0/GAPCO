class Goal < ApplicationRecord
  validates :title, presence: true
  belongs_to :recommendation
end
